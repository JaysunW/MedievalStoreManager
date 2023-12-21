using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DecreaseFishAmount : MonoBehaviour
{
    List<GameObject> fish = new List<GameObject>();
    List<GameObject> deactivatedFish = new List<GameObject>();

    public int maxFishCount = 20;
    private int distanceFishReactivate = 9;

    void Start()
    {
        distanceFishReactivate = (int) ActivateBlocks.Instance.GetactiveCircle() - 4;
    }

    void OnTriggerEnter2D(Collider2D other) {
        if (other.tag == "Fish")
        {
            fish.Add(other.gameObject.transform.parent.parent.gameObject);
            if(fish.Count > maxFishCount)
            {   
                DeactivateFurthestFish();
            }
        }
    }

    void Update()
    {
        if(fish.Count < maxFishCount && deactivatedFish.Count > 0)
        {
            ActivateFishAgain();
        }
    }

    private void DeactivateFurthestFish()
    {
        int _fishIndex = FindFurthestFish();
        deactivatedFish.Add(fish[_fishIndex]);
        fish[_fishIndex].active = false;
    }

    private int FindFurthestFish()
    {
        float _biggestDis = -Mathf.Infinity;
        int _index = 0;
        for(int i = 0; i < fish.Count; i++)
        {
            if(fish[i] != null)
            {
                float _disToPlayer = GiveDistanceBetweenTwoPoints((Vector2) this.transform.position, (Vector2) fish[i].transform.position);
                if(_disToPlayer > _biggestDis)
                {
                    _biggestDis = _disToPlayer;
                    _index = i;
                }
            }
        }
        return _index;
    }

    private void ActivateFishAgain()
    {
        for(int i = 0; i < deactivatedFish.Count; i++)
        {
            float _disToPlayer = GiveDistanceBetweenTwoPoints((Vector2) this.transform.position, (Vector2) deactivatedFish[i].transform.position);
            if(_disToPlayer > distanceFishReactivate)
            {
                deactivatedFish[i].GetComponent<FishBehaviour>().DeactivateFish();;
                deactivatedFish.RemoveAt(i);
            }
        }
    }

    private float GiveDistanceBetweenTwoPoints(Vector2 pointA, Vector2 pointB)
	{
		Vector2 output = new Vector2(
			pointB.x-pointA.x,
			pointB.y-pointA.y
		);
		return output.magnitude;
	}

    private void OnTriggerExit2D(Collider2D other) {
        if (other.tag == "Fish")
        {
            fish.Remove(SearchForLeavingFishIndex(other.gameObject.transform.parent.parent.gameObject));
        } 
    }

    public void RemoveCaughtOrDeadFish(GameObject _fish)
    {
        fish.Remove(SearchForLeavingFishIndex(_fish));
    }

    private GameObject SearchForLeavingFishIndex(GameObject _fish)
    {
        for(int i = 0; i < fish.Count; i++)
        {   
            if(_fish == fish[i])
            {   
                return fish[i];
            }
        }
        return null;
    }

}
