using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FishClassScript : MonoBehaviour
{
    public List<FishClass> fishes = new List<FishClass>();

    [HideInInspector]
    public int[] smallFishSpeedHealth;
    [HideInInspector]
    public int[] mediumFishSpeedHealth;
    [HideInInspector]
    public int[] bigFishSpeedHealth;

    public void Start()
    {
        FishOverview.Instance.SetFishClass(this.gameObject.GetComponent<FishClassScript>());
    }

    public void AddFishIntoList(Vector2 _fishPosition, GridObjectEnum _gridObject, int _index)
    {
        switch(_gridObject)
        {
            case GridObjectEnum.SmallFish:
                fishes.Add(new SmallFish(_gridObject,"FishSmall",_fishPosition,smallFishSpeedHealth[0],smallFishSpeedHealth[1],_index, 0));
            break;
            case GridObjectEnum.MediumFish:
                fishes.Add(new MediumFish(_gridObject,"FishMedium",_fishPosition,smallFishSpeedHealth[0],smallFishSpeedHealth[1],_index, 1));
            break;
            case GridObjectEnum.BigFish:
                fishes.Add(new BigFish(_gridObject,"FishBig", _fishPosition,smallFishSpeedHealth[0],smallFishSpeedHealth[1],_index, 2));
            break;
        }
    }

    public class FishClass
    {
        public GameObject fishObject;
        public Rigidbody2D rb;
        public Vector2 worldPos;
        public GridObjectEnum type;
        public FishStats fishStats;
        public int speed;
        public int tier;
        public int index;
        public int health;

        public void FirstThingsToDo()
        {
            fishStats = this.fishObject.GetComponent<FishStats>();
            MoveThisFishIntoPosition();
            GiveTheFishScriptItsInfo();
        }

        private void MoveThisFishIntoPosition()
        {
            this.fishObject.transform.position = this.worldPos;
        }

        private void GiveTheFishScriptItsInfo()
        {
            fishStats.SetSpeed(speed);
            fishStats.SetIndex(index);
            fishStats.SetType(type);
            fishStats.SetTier(tier);
            fishStats.SetHealth(health);
            fishStats.SetSpeed(speed);
        }

        public void  FishGotCaught()
        {
            Destroy(this.fishObject);
        }

        public void FishGotKilled()
        {
            Destroy(this.fishObject);
        }
    }

    public class PassivFish : FishClass
    {
        public PassivFish(GridObjectEnum _type,string _name, Vector2 _fishPosition, int _speed,int _health, int _index, int _tier)
        {
            this.type = _type;
            this.worldPos = _fishPosition;
            this.speed = _speed;
            this.index = _index;
            this.health = _health;
            this.tier = _tier;
            this.fishObject = (GameObject) Instantiate(Resources.Load(_name));
            FirstThingsToDo();
        }
    }

    public class SmallFish : PassivFish
    {
        public SmallFish(GridObjectEnum _type, string _name, Vector2 _fishPosition, int _speed,int _health, int _index, int _tier)
        : base (_type, _name, _fishPosition, _speed, _health, _index, _tier)
        {
        }
    }

    public class MediumFish : PassivFish
    {
        public MediumFish(GridObjectEnum _type, string _name, Vector2 _fishPosition, int _speed,int _health, int _index, int _tier)
        : base (_type, _name, _fishPosition, _speed, _health, _index, _tier)
        {
        }
    }

    public class BigFish : PassivFish
    {
        public BigFish(GridObjectEnum _type, string _name, Vector2 _fishPosition, int _speed,int _health, int _index, int _tier)
        : base (_type, _name, _fishPosition, _speed, _health, _index, _tier)
        {
        }
    }
}
