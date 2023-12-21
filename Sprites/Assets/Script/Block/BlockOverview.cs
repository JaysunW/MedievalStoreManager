using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class BlockOverview : MonoBehaviour
{

    public static BlockOverview Instance { get; private set; }      // making a instance of this script so its saves the changes made between scenes

    public BlockClassScript blockClass;

    [Header("Area1Object Settings")]     // all the settings for the specific Stones

    public int area1ObjectValue = 10;
    public int area1ObjectSpawnSpecial = 1;
    public int area1ObjectGemSpawn = 70;
    public int area1ObjectJuwelSpawn = 10;
    
    [Header("Area2Object Settings")]

    public int area2ObjectValue = 20;
    public int area2ObjectSpawnSpecial = 15;
    public int area2ObjectGemSpawn = 80;
    public int area2ObjectJuwelSpawn = 20;

    [Header("Area3Object Settings")]

    public int area3ObjectValue = 30;
    public int area3ObjectSpawnSpecial = 5;
    public int area3ObjectGemSpawn = 60;
    public int area3ObjectJuwelSpawn = 30;
    
    [Header("Area4Object Settings")]

    public int area4ObjectValue = 40;
    public int area4ObjectSpawnSpecial = 10;
    public int area4ObjectGemSpawn = 30;
    public int area4ObjectJuwelSpawn = 30;
    
    [Header("Area5Object Settings")]

    public int area5ObjectValue = 40;
    public int area5ObjectSpawnSpecial = 10;
    public int area5ObjectGemSpawn = 30;
    public int area5ObjectJuwelSpawn = 30;
    
    private string sceneName;

    //[Header("All Settings")]

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
        if(sceneName.Equals("Level1"))
        {
        PutChancesIntoTheirArrayForClass();
        }
    }

    public void SetBlockClass(BlockClassScript _blockClass)
    {
        blockClass = _blockClass;
    }

    private void PutChancesIntoTheirArrayForClass()
    {
        blockClass.area1SpawnChance = new int [] { area1ObjectSpawnSpecial, area1ObjectGemSpawn, area1ObjectJuwelSpawn};
        blockClass.area2SpawnChance = new int [] { area2ObjectSpawnSpecial, area2ObjectGemSpawn, area2ObjectJuwelSpawn};
        blockClass.area3SpawnChance = new int [] { area3ObjectSpawnSpecial, area3ObjectGemSpawn, area3ObjectJuwelSpawn};
        blockClass.area4SpawnChance = new int [] { area4ObjectSpawnSpecial, area4ObjectGemSpawn, area4ObjectJuwelSpawn};
        blockClass.area5SpawnChance = new int [] { area5ObjectSpawnSpecial, area5ObjectGemSpawn, area5ObjectJuwelSpawn};
    }

    public void AddTileToGridObjectList(Vector2Int _colRow, Vector2 _blockPosition, GridObjectEnum _name, int _index, string _sidesForObjects)   // adding the corresponding object into the block array
    {
        blockClass.AddToGridList(_colRow,_blockPosition,_name,_index,_sidesForObjects); 
    }

    public bool ChanceInAHundred(float _chanceToHit)
    {
        int _objectChance = (int) Random.Range(0,100f);
        if(_objectChance < _chanceToHit){
            return true;
        }
        return false;
    }
}
