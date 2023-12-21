using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GlossarSave : MonoBehaviour
{
    public static GlossarSave Instance { get; private set; }      // making a instance of this script so its saves the changes made between scenes

    public GemstoneGlossar [] gemstone;
    public ChestGlossar [] chest;
    public FishGlossar [] fish;

    public Glossar [] glossar;

    private int glossarLength;

    // Start is called before the first frame update
    void Awake()
    {
        if(Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(gameObject);
        }else
        {
            Destroy(gameObject);
        }
        PopulateGemstoneIndex();
        PopulateChestIndex();
        glossarLength = gemstone.Length + chest.Length + fish.Length;
    }

    public Glossar [] GetCurrentGlossarArray()
    {
        PutAllArraysIntoList();
        return glossar;
    }

    public GemstoneGlossar [] GetGemstoneArray()
    {
        return gemstone;
    }
    public ChestGlossar [] GetChestArray()
    {
        return chest;
    }
    public FishGlossar [] GetFishArray()
    {
        return fish;
    }

    private void PutAllArraysIntoList()
    {
        int arrayIndex = 0;
        glossar = new Glossar[glossarLength];
        for(int i =0;i < gemstone.Length; i++)
        {
            glossar[i + arrayIndex] = new Glossar();
            glossar[i + arrayIndex].sprite = gemstone[i].sprite;
            glossar[i + arrayIndex].name = gemstone[i].name;
            glossar[i + arrayIndex].description = gemstone[i].description;
            glossar[i + arrayIndex].found = gemstone[i].found;
        }
        arrayIndex += gemstone.Length;
        for(int i =0;i < chest.Length; i++)
        {
            glossar[i + arrayIndex] = new Glossar();
            glossar[i + arrayIndex].sprite = chest[i].sprite;
            glossar[i + arrayIndex].name = chest[i].name;
            glossar[i + arrayIndex].description = chest[i].description;
            glossar[i + arrayIndex].found = chest[i].found;
        }
        arrayIndex += chest.Length; 
        for(int i =0;i < fish.Length; i++)
        {
            glossar[i + arrayIndex] = new Glossar();
            glossar[i + arrayIndex].sprite = fish[i].sprite;
            glossar[i + arrayIndex].name = fish[i].name;
            glossar[i + arrayIndex].description = fish[i].description;
            glossar[i + arrayIndex].found = fish[i].found;
            glossar[i + arrayIndex].rotate = true;
        }
    }

    public void SetGlossar(bool [] _inputArray)
    {
        if(glossar.Length != glossarLength)
        {
            PutAllArraysIntoList();
        }
        for(int i = 0; i < glossar.Length; i++)
        {
            glossar[i].found = _inputArray[i];
        }
        PutAllGlossarBack();
    }

    private void PutAllGlossarBack()
    {
        int arrayIndex = 0;
        
        for(int i =0;i < gemstone.Length; i++)
        {
            gemstone[i].found = glossar[i + arrayIndex].found;
        }
        arrayIndex += gemstone.Length;
        for(int i =0;i < chest.Length; i++)
        {
            chest[i].found = glossar[i + arrayIndex].found;
        }
        arrayIndex += chest.Length; 
        for(int i =0;i < fish.Length; i++)
        {
            fish[i].found = glossar[i + arrayIndex].found;
        }
    }

    public Glossar [] GetFoundObjects()
    {
        PutAllArraysIntoList();
        return glossar;
    }

    public void PopulateGemstoneIndex()
    {
        for(int i = 0; i< gemstone.Length; i++)
        {
            gemstone[i].index = i;
        }
    }

    public void GemstoneFound(GemstoneNameEnum _gemstoneName)
    {
        int _save = 0;
        for(int i = 0; i< gemstone.Length; i++)
        {
            if(gemstone[i].enumName == _gemstoneName)
            {
                _save = i;
            }
        }
        if(gemstone[_save].found != true)
            gemstone[_save].found = true; 
    }

    public void FishFound(FishNameEnum _fishName)
    {
        int _save = 0;
        for(int i = 0; i< fish.Length; i++)
        {
            if(fish[i].enumName == _fishName)
            {
                _save = i;
            }
        }
        if(fish[_save].found != true)
            fish[_save].found = true; 
    }

    public void PopulateChestIndex()
    {
        for(int i = 0; i< chest.Length; i++)
        {
            chest[i].index = i;
        }
    }

    public void ChestFound(ChestEnum _chestName)
    {
        int _save = 0;
        for(int i = 0; i< chest.Length; i++)
        {
            if(chest[i].enumName == _chestName)
            {
                _save = i;
            }
        }
        if(chest[_save].found != true)
            chest[_save].found = true; 
    }


}
