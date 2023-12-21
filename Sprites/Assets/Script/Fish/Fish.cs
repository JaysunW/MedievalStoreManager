using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class Fish
{
    public Sprite sprite;
    public FishNameEnum fishName;
    public int chanceToSpawn;
    public int value;
    public int speedChange;
    public int healthChange;
    public bool aggressive;
    public int damage;
    public int colliderX = 1;
    public int colliderY = 1;
}
