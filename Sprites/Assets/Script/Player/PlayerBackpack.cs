using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerBackpack : MonoBehaviour
{
    public static PlayerBackpack Instance { get; private set; }

    [Header("Backpack Settings")]
    
    public List<Gemstones> gemBackpack = new List<Gemstones>(),jewelBackpack = new List<Gemstones>();
    public List<Fish> smallFishBackpack = new List<Fish>(),mediumFishBackpack = new List<Fish>(),bigFishBackpack = new List<Fish>();
    private bool gemBackpackFull = false, jewelBackpackFull = false, artifactBackpackFull = false;
    private bool smallFishBackpackFull = false, mediumFishBackpackFull = false, bigFishBackpackFull = false;

    public int maxOfGem = 10;
    public int maxOfJewel = 5;
    public int maxOfArtifact = 2;

    private int maxSmallFish = 8;
    private int maxMediumFish;
    private int maxBigFish;

    private int maxSmallFishPart = 16;
    private int maxMediumFishPart;
    private int maxBigFishPart;

    private void Awake()
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

    public void PopulateBackpackMaximums()
    {
        maxMediumFish = maxSmallFish/2;
        maxBigFish = maxMediumFish/4;

        maxMediumFishPart = maxSmallFishPart/4;
        maxBigFishPart = maxMediumFishPart/4;
    }

    public void AddFish(GridObjectEnum _name, Fish _fish)
    {
        switch(_name)
        {
            case GridObjectEnum.SmallFish:
                if(smallFishBackpack.Count == maxSmallFish-1)
                {
                    Debug.Log("Backpack full SmallFish");
                    smallFishBackpackFull = true;
                    // Tell Player that he is full
                }
                else if(smallFishBackpack.Count < maxSmallFish)
                {
                    smallFishBackpack.Add(_fish);
                    GlossarSave.Instance.FishFound(_fish.fishName);
                }
            break;
            case GridObjectEnum.MediumFish:
                if(mediumFishBackpack.Count == maxMediumFish-1)
                {
                    Debug.Log("Backpack full mediumFish");
                    mediumFishBackpackFull = true;
                    // Tell Player that he is full
                }
                else if(mediumFishBackpack.Count < maxMediumFish)
                {
                    mediumFishBackpack.Add(_fish);
                    GlossarSave.Instance.FishFound(_fish.fishName);
                }
            break;
            case GridObjectEnum.BigFish:
                if(bigFishBackpack.Count == maxBigFish-1)
                {
                    Debug.Log("Backpack full BigFish");
                    bigFishBackpackFull = true;
                    // Tell Player that he is full
                }
                else if(bigFishBackpack.Count < maxBigFish)
                {
                    bigFishBackpack.Add(_fish);
                    GlossarSave.Instance.FishFound(_fish.fishName);
                }
            break;
        }
    }

    public void AddGemstoneDropToBackpack(SpecialDropEnum _name, Gemstones _gemstoneName)
    {
        switch(_name)
        {
            case SpecialDropEnum.Gem:
                if(gemBackpack.Count == maxOfGem-1)
                {
                    Debug.Log("Backpack full Gem");
                    gemBackpackFull = true;
                    // Tell Player that he is full
                }else if(gemBackpack.Count < maxOfGem)
                {
                    gemBackpack.Add(_gemstoneName);
                    GlossarSave.Instance.GemstoneFound(_gemstoneName.gemstoneName);
                }
            break;
            case SpecialDropEnum.Jewel:

                if(jewelBackpack.Count == maxOfJewel-1)
                {
                    Debug.Log("Backpack full Jewel");
                    jewelBackpackFull = true;
                    // Tell Player that he is full
                }
                else if(jewelBackpack.Count < maxOfJewel)
                {
                    jewelBackpack.Add(_gemstoneName);
                    GlossarSave.Instance.GemstoneFound(_gemstoneName.gemstoneName);
                }
            break;
        }
    }

    public bool IsBackpackEmpty()
    {
        if(gemBackpack.Count > 0 || jewelBackpack.Count > 0 || smallFishBackpack.Count > 0 || mediumFishBackpack.Count > 0|| bigFishBackpack.Count > 0 )
            return false;
        return true;
    }

    public bool GetGemBackpackFull()
    {
        return gemBackpackFull;
    }

    public bool GetJewelBackpackFull()
    {
        return jewelBackpackFull;
    }

    public bool GetArtifactBackpackFull()
    {
        return artifactBackpackFull;
    }

    public bool GetSmallFishBackpackFull()
    {
        return smallFishBackpackFull;
    }
    public bool GetMediumFishBackpackFull()
    {
        return mediumFishBackpackFull;
    }
    public bool GetBigFishBackpackFull()
    {
        return bigFishBackpackFull;
    }

    public bool GetFishBackpackBool(GridObjectEnum _input)
    {
        switch(_input)
        {
            case GridObjectEnum.SmallFish:
                return smallFishBackpackFull;
            break;
            case GridObjectEnum.MediumFish:
                return mediumFishBackpackFull;
            break;
            case GridObjectEnum.BigFish:
                return bigFishBackpackFull;
            break;
        }
        return true;
    }

    public List<Fish> GetSmallFishBackpack()
    {
        return smallFishBackpack;
    }

    public List<Fish> GetMediumFishBackpack()
    {
        return mediumFishBackpack;
    }

    public List<Fish> GetBigFishBackpack()
    {
        return bigFishBackpack;
    }

    public List<Gemstones> GetGemBackpack()
    {
        return gemBackpack;
    }

    public List<Gemstones> GetJewelBackpack()
    {
        return jewelBackpack;
    }

    public void ClearBackpack()
    {
        gemBackpackFull = false;
        jewelBackpackFull = false;
        artifactBackpackFull = false;
        smallFishBackpackFull = false;
        mediumFishBackpackFull = false;
        bigFishBackpackFull = false;
        gemBackpack.Clear();
        jewelBackpack.Clear();
        smallFishBackpack.Clear();
        mediumFishBackpack.Clear();
        bigFishBackpack.Clear();
    }
}
