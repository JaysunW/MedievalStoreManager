using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SaveMerge : MonoBehaviour
{
    public static SaveMerge Instance { get; private set; }

    [HideInInspector]
    public int goldAmount;
    [HideInInspector]
    public int kaescherTier;
    [HideInInspector]
    public int laserTier;
    [HideInInspector]
    public int knifeTier;
    [HideInInspector]
    public int o2Tier;
    [HideInInspector]
    public bool [] glossarFoundObjects;
    [HideInInspector]
    public Glossar [] glossar;

    private Shop shop;

    void Awake()
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
    }

    public void SetShop(Shop _shop)
    {
        shop = _shop;
    }

    public void SetVariables()
    {
        goldAmount = PlayerStats.Instance.GetGold();
        kaescherTier = Tools.Instance.GetNetMk();
        laserTier = Tools.Instance.GetLaserMk();
        knifeTier = Tools.Instance.GetKnifeMk();
        o2Tier = PlayerStats.Instance.Geto2Mk();
        FoundObjects(GlossarSave.Instance.GetFoundObjects());
    }

    public void FoundObjects(Glossar [] _glossar)
    {
        glossar = _glossar;
        glossarFoundObjects = new bool [glossar.Length];
        for(int i=0;i<glossar.Length; i++)
        {
            glossarFoundObjects[i] = glossar[i].found;
        }
    }

    public void loadVariablesBack(GameData data)
    {
        Debug.Log("Goldamount: " + goldAmount + " kaescherTier: " + kaescherTier+ " laserTier: " 
        + laserTier+ " knifeTier: " + knifeTier+ " o2Tier: " + o2Tier);

        PlayerStats.Instance.SetGold(data.goldAmount);
        shop.SetFishingNet(data.kaescherTier);
        shop.SetLaser(data.laserTier);
        shop.SetKnife(data.knifeTier);
        shop.SetO2(data.o2Tier);
        GlossarSave.Instance.SetGlossar(data.glossarFoundObjects);
        PlayerBackpack.Instance.ClearBackpack();
    }

    public void SaveData()
    {
        SetVariables();
        SaveSystem.SaveData(SaveMerge.Instance);
    }

    public void LoadData()
    {
        GameData data = SaveSystem.LoadData();
        loadVariablesBack(data);
    }

    public void ResetAll()
    {
        GameData data = SaveSystem.Reset();
        loadVariablesBack(data);
    }
}
