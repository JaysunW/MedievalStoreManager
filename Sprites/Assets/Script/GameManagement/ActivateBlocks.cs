using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class ActivateBlocks : MonoBehaviour
{
    public static ActivateBlocks Instance { get; private set; } 

    List<GridObjectList> activeObject = new List<GridObjectList>();
    List<GridObjectList> deactivated1Object = new List<GridObjectList>();
    List<GridObjectList> deactivated2Object = new List<GridObjectList>();
    List<GridObjectList> deactivated3Object = new List<GridObjectList>();
    List<GridObjectList> deactivated4Object = new List<GridObjectList>();
    List<GridObjectList> deactivated5Object = new List<GridObjectList>();

    List<GridObjectList> mediumFishObject = new List<GridObjectList>();
    List<GridObjectList> bigFishObject = new List<GridObjectList>();

    List<GridObjectList> deactivatedMainBorder = new List<GridObjectList>();
    List<GridObjectList> deactivatedObjects = new List<GridObjectList>();

    private string sceneName;

    public float activeCircle = 10;

    private GameObject player;

    private bool active = true;

    public float GetactiveCircle()
    {
        return activeCircle;
    }

    public void SetPlayer(GameObject _player)
    {
        player = _player;
        activeObject.Clear();
        deactivatedMainBorder.Clear();
        deactivatedObjects.Clear();
        deactivated1Object.Clear();
        deactivated2Object.Clear();
        deactivated3Object.Clear();
        deactivated4Object.Clear();
        deactivated5Object.Clear();
        mediumFishObject.Clear();
        bigFishObject.Clear();
        Scene currentScene = SceneManager.GetActiveScene();
        sceneName = currentScene.name;
    }

    private void Awake()        // setting it up so there is only one instance of the script
    {       
        if(Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(gameObject);
        }
        else
        {
            Destroy(gameObject);
        }
        Scene currentScene = SceneManager.GetActiveScene();
        sceneName = currentScene.name;
    }

    public void ChangeActive(bool _input)
    {
        active = _input;
    }

    public void AddTodeactivatedLists(GameObject _object,GridObjectEnum _enum)
    {
        if(_enum == GridObjectEnum.Area1Object || _enum == GridObjectEnum.Border1Object)
        {
            deactivated1Object.Add(new GridObjectList(_object,_enum));
            return;
        }else if(_enum == GridObjectEnum.Area2Object || _enum == GridObjectEnum.Border2Object)
        {
            deactivated2Object.Add(new GridObjectList(_object,_enum));
            return;
        }else if(_enum == GridObjectEnum.Area3Object || _enum == GridObjectEnum.Border3Object)
        {
            deactivated3Object.Add(new GridObjectList(_object,_enum));
            return;
        }else if(_enum == GridObjectEnum.Area4Object || _enum == GridObjectEnum.Border4Object)
        {
            deactivated4Object.Add(new GridObjectList(_object,_enum));
            return;
        }
        else if(_enum == GridObjectEnum.Area5Object || _enum == GridObjectEnum.Border5Object)
        {
            deactivated5Object.Add(new GridObjectList(_object,_enum));
            return;
        }
        else if(_enum == GridObjectEnum.MainBorder)
        {
            deactivatedMainBorder.Add(new GridObjectList(_object,_enum));
            return;
        }
        else if(_enum == GridObjectEnum.Shell1 || _enum == GridObjectEnum.Coral1 || _enum == GridObjectEnum.Chest1
        || _enum == GridObjectEnum.SmallFish)
        {
            deactivatedObjects.Add(new GridObjectList(_object,_enum));
            return;
        }
        else if(_enum == GridObjectEnum.MediumFish)
        {
            mediumFishObject.Add(new GridObjectList(_object,_enum));
        }
        else if( _enum == GridObjectEnum.BigFish)
        {
            bigFishObject.Add(new GridObjectList(_object,_enum));
        }
    }

    private void searchTroughMediumFish()
    {
        for(int i = 0; i < mediumFishObject.Count; i++)
        {
            if(GiveDistanceBetweenTwoPoints((Vector2) mediumFishObject[i].inListObject.transform.position,(Vector2) player.transform.position) < activeCircle)
            {
                mediumFishObject[i].inListObject.active = true;
                activeObject.Add(mediumFishObject[i]);
                mediumFishObject.Remove(mediumFishObject[i]);
            }
        }
    }

    private void searchTroughBigFish()
    {
        for(int i = 0; i < bigFishObject.Count; i++)
        {
            if(GiveDistanceBetweenTwoPoints((Vector2) bigFishObject[i].inListObject.transform.position,(Vector2) player.transform.position) < activeCircle)
            {
                bigFishObject[i].inListObject.active = true;
                activeObject.Add(bigFishObject[i]);
                bigFishObject.Remove(bigFishObject[i]);
            }
        }
    }

    private void searchTroughBorder()
    {
        for(int i = 0; i < deactivatedMainBorder.Count; i++)
        {
            if(GiveDistanceBetweenTwoPoints((Vector2) deactivatedMainBorder[i].inListObject.transform.position,(Vector2) player.transform.position) < activeCircle)
            {
                deactivatedMainBorder[i].inListObject.active = true;
                activeObject.Add(deactivatedMainBorder[i]);
                deactivatedMainBorder.Remove(deactivatedMainBorder[i]);
            }
        }
    }

    private void searchTroughArea1()
    {
        for(int i = 0; i < deactivated1Object.Count; i++)
        {
            if(GiveDistanceBetweenTwoPoints((Vector2) deactivated1Object[i].inListObject.transform.position,(Vector2) player.transform.position) < activeCircle)
            {
                deactivated1Object[i].inListObject.active = true;
                activeObject.Add(deactivated1Object[i]);
                deactivated1Object.Remove(deactivated1Object[i]);
            }
        }
    }

    private void searchTroughArea2()
    {
        for(int i = 0; i < deactivated2Object.Count; i++)
        {
            if(GiveDistanceBetweenTwoPoints((Vector2) deactivated2Object[i].inListObject.transform.position,(Vector2) player.transform.position) < activeCircle)
            {
                deactivated2Object[i].inListObject.active = true;
                activeObject.Add(deactivated2Object[i]);
                deactivated2Object.Remove(deactivated2Object[i]);
            }
        }
    }
    private void searchTroughArea3()
    {
        for(int i = 0; i < deactivated3Object.Count; i++)
        {
            if(GiveDistanceBetweenTwoPoints((Vector2) deactivated3Object[i].inListObject.transform.position,(Vector2) player.transform.position) < activeCircle)
            {
                deactivated3Object[i].inListObject.active = true;
                activeObject.Add(deactivated3Object[i]);
                deactivated3Object.Remove(deactivated3Object[i]);
            }
        }
    }
    private void searchTroughArea4()
    {
        for(int i = 0; i < deactivated4Object.Count; i++)
        {
            if(GiveDistanceBetweenTwoPoints((Vector2) deactivated4Object[i].inListObject.transform.position,(Vector2) player.transform.position) < activeCircle)
            {
                deactivated4Object[i].inListObject.active = true;
                activeObject.Add(deactivated4Object[i]);
                deactivated4Object.Remove(deactivated4Object[i]);
            }
        }
    }
    private void searchTroughArea5()
    {
        for(int i = 0; i < deactivated5Object.Count; i++)
        {
            if(GiveDistanceBetweenTwoPoints((Vector2) deactivated5Object[i].inListObject.transform.position,(Vector2) player.transform.position) < activeCircle)
            {
                deactivated5Object[i].inListObject.active = true;
                activeObject.Add(deactivated5Object[i]);
                deactivated5Object.Remove(deactivated5Object[i]);
            }
        }
    }

    void Update()
    {
        if(sceneName.Equals("Level1"))
        if(active && player != null)
        {
            int border = GridManagerStats.Instance.InWhichBorderIsThisRow((int)player.transform.position.y);
            switch(border)
            {
                case 0:
                    searchTroughArea1();
                    searchTroughArea2();
                break;
                case 1:
                    searchTroughMediumFish();
                    searchTroughArea1();
                    searchTroughArea2();
                    searchTroughArea3();
                break;
                case 2:
                    searchTroughMediumFish();
                    searchTroughArea2();
                    searchTroughArea3();
                    searchTroughArea4();
                break;
                case 3:
                    searchTroughMediumFish();
                    searchTroughBigFish();
                    searchTroughArea3();
                    searchTroughArea4();
                    searchTroughArea5();
                break;
                case 4:
                    searchTroughMediumFish();
                    searchTroughBigFish();
                    searchTroughArea4();
                    searchTroughArea5();
                break;
            }

            if(player.transform.position.x < 25 || player.transform.position.x > GridManagerStats.Instance.GetCols()-25)
            {
                searchTroughBorder();
            }

            for(int i = 0; i < deactivatedObjects.Count; i++)
            {
                if(GiveDistanceBetweenTwoPoints((Vector2) deactivatedObjects[i].inListObject.transform.position,(Vector2) player.transform.position) < activeCircle)
                {
                    deactivatedObjects[i].inListObject.active = true;
                    activeObject.Add(deactivatedObjects[i]);
                    deactivatedObjects.Remove(deactivatedObjects[i]);
                }
            }
            for(int i = 0; i < activeObject.Count;i++)
            {
                if(activeObject[i].inListObject != null)
                {
                    if(GiveDistanceBetweenTwoPoints((Vector2) activeObject[i].inListObject.transform.position,(Vector2) player.transform.position) >= activeCircle)
                    {
                        AddTodeactivatedLists(activeObject[i].inListObject,activeObject[i].enumDesciption);
                        activeObject[i].inListObject.active = false;
                        activeObject.Remove(activeObject[i]);
                    }
                }else
                {
                    activeObject.Remove(activeObject[i]);
                }
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

    public class GridObjectList
    {
        public GameObject inListObject;
        public GridObjectEnum enumDesciption;

        public GridObjectList(GameObject _object, GridObjectEnum _enum)
        {
            inListObject = _object;
            enumDesciption = _enum;
        }
    }
}
