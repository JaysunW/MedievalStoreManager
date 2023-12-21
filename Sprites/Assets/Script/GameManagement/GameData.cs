using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class GameData
{
    public int goldAmount;
    public int kaescherTier;
    public int laserTier;
    public int knifeTier;
    public int o2Tier;
    public bool [] glossarFoundObjects;

    public GameData(SaveMerge saveMerge)
    {
        goldAmount = saveMerge.goldAmount;
        kaescherTier = saveMerge.kaescherTier;
        laserTier = saveMerge.laserTier;
        knifeTier = saveMerge.knifeTier;
        o2Tier = saveMerge.o2Tier;
        glossarFoundObjects = saveMerge.glossarFoundObjects;
    }
}
