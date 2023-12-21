using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class FishOverview : MonoBehaviour
{
    public static FishOverview Instance { get; private set; }      // making a instance of this script so its saves the changes made between scenes

    public FishClassScript fishClass;

    [Header("SmallFish Settings")]

    public int smallFishSpeed = 10;
    public int smallFishHealth = 50;

    [Header("MediumFish Settings")]

    public int mediumFishSpeed = 10;
    public int mediumFishHealth = 100;

    [Header("BigFish Settings")]

    public int bigFishSpeed = 10;
    public int bigFishHealth = 150;

    private string sceneName;

    private void Awake()        // setting it up so there is only one instance of this script
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
        if(sceneName.Equals("Level1"))
        {
        PutIntIntoTheirArrayForClass();
        }
    }

    public void SetFishClass(FishClassScript _fishClass)
    {
        fishClass = _fishClass;
    }

    private void PutIntIntoTheirArrayForClass()
    {
        fishClass.smallFishSpeedHealth = new int [] { smallFishSpeed, smallFishHealth};
        fishClass.mediumFishSpeedHealth = new int [] { mediumFishSpeed, mediumFishHealth};
        fishClass.bigFishSpeedHealth = new int [] { bigFishSpeed, bigFishHealth};
    }

    public void AddFishIntoObjectList(Vector2 _fishPosition, GridObjectEnum _name, int _index)
    {
        fishClass.AddFishIntoList(_fishPosition, _name, _index);
    }
}
