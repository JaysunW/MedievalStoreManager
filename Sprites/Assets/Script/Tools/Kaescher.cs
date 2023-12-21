using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Kaescher : MonoBehaviour
{
    private int kaescherMk;
    private float kaescherCooldown;
    private float kaescherRange;

    public bool kaescherIsInCooldown = false;
    public Sprite[] kaescherSkins;
    
    private LayerMask fishMask = 1<<13;

    public Transform netPoint;

    public DecreaseFishAmount decreaseFishAmount;

    private string currentSceneName;

    void Start()
    {
        currentSceneName = SceneManager.GetActiveScene().name;
        UpdateSkin();
    }

    void Update()
    {
        if(Input.GetButtonDown("Fire1") && !kaescherIsInCooldown && currentSceneName != "Shop")    // when left mouse is pressed start the laser Renderer
        {
            KaescherSwing();
        }  
    }

    public void UpdateSkin()
    {
        this.GetComponent<SpriteRenderer>().sprite = kaescherSkins[Tools.Instance.kaescherMK];
    }

    public void GetTheToolInfo(int _kaescherMk, float _kaescherCooldown, float _kaescherRange)
    {
        kaescherMk = _kaescherMk;
        kaescherCooldown = _kaescherCooldown;
        kaescherRange = _kaescherRange;
    }

    void OnDrawGizmos() // To draw the visualization for the programmer
    {
        if(netPoint == null)
        return;

        Gizmos.DrawWireSphere(netPoint.position, kaescherRange);
    }

    private void KaescherSwing()
    {
        FishCatch();
        StartCoroutine(KaescherCooldown());
    }

    private void FishCatch()
    {   
        Collider2D[] hitFish = Physics2D.OverlapCircleAll(netPoint.position, kaescherRange, fishMask);
        foreach(Collider2D fish in hitFish)
        {
            
            if(fish.transform.parent.parent.gameObject.GetComponent<FishStats>() != null)
            {
                FishStats _fishStats = fish.transform.parent.parent.gameObject.GetComponent<FishStats>();
                if(!PlayerBackpack.Instance.GetFishBackpackBool(_fishStats.GetType()))
                {
                    decreaseFishAmount.RemoveCaughtOrDeadFish(fish.transform.parent.parent.gameObject);
                    fish.transform.parent.parent.gameObject.GetComponent<FishStats>().FishCaught(kaescherMk);
                }
            }
        }
    }

    public void Reset()
    {
        kaescherIsInCooldown = false;
        transform.localScale = Vector3.one;
    }

    IEnumerator KaescherCooldown()
    {
        kaescherIsInCooldown = true;
        transform.localScale = Vector3.one * 2f; // Only for the visiualization for now
        float timer = 0;
        while ( timer < kaescherCooldown)
        {
            timer += Time.deltaTime;
            yield return new WaitForSeconds(.001f);
        }
        transform.localScale = Vector3.one; // Only for the visiualization for now
        kaescherIsInCooldown = false;
    }
}
