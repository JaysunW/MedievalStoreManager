using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GridManagerStats : MonoBehaviour
{

    public static GridManagerStats Instance { get; private set; }      // making a instance of this script so its saves the changes made between scenes

    public bool testForSpecificGridObjectsInGrid;

    // Only here for test purposes
    public GridObjectEnum test1;
    public GridObjectEnum test2;
    public GridObjectEnum test3;

    [Header ("Grid Settings")]
    public int rows = 50;
    public int cols = 50;

    public float tileSize = 1f;  // size of the tiles

    [HideInInspector]
    public GridObjectEnum[,] grid;  // The grid itself saves where a block is placed

    private int[] border;   // rows where the border is place

    public int borderAmount = 4;    // how many borders there are 
    public int howManyAreaObjects = 5;

    [Header ("Spawn Settings")]

    public int areaBlockPercent = 50;  // density of blocks
    public float chanceSpawnStartBlock = 1;
    public int chanceSpawnCoral = 20;
    public int chanceSpawnShell = 20;
    public int chanceSpawnAFish = 20;
    public float chanceSpawn2x2Wreck = 100;
    public float chanceSpawn3x2Wreck = 100;
    public int chanceSpawnSingleChest = 80;

    [Header ("Fish Spawn Settings")]

    public int smallFishSpawn = 60;
    public int mediumFishSpawn = 80;
    public int bigFishSpawn = 60;

    private int rowsPerArea;

    
    private string Wreck2x2Prefab = "WreckBa";
    private string Wreck3x2Prefab = "Wreck3x2Ba";
    private string singleChest = "SingleChest";
    private string doubleChest = "DoubleChest";


    public FishOverview fishOverview;

    public int GetCols()
    {
        return cols;
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
    }

    private void Start()
    {
        borderAmount++; // borderAmount plus one so it stays at the amount the programmer typed in
    }

    private void Update()
    {

        // ONLY FOR TEST PURPOSES
        if(testForSpecificGridObjectsInGrid)
        {
            if (Input.GetKeyDown(KeyCode.Keypad0))
            {
                TestForSpecificGridObject(test1, testColour[0]);
            }
            if (Input.GetKeyDown(KeyCode.Keypad1))
            {
                TestForSpecificGridObject(test2, testColour[1]);
            }
            if (Input.GetKeyDown(KeyCode.Keypad2))
            {
                TestForSpecificGridObject(test3, testColour[2]);
            }
        }
        
    }

    // ONLY FOR TEST PURPOSES
    private string[] testColour = new string [] { "Test1", "Test2", "Test3", "Test4"};

    // ONLY FOR TEST PURPOSES
    private void TestForSpecificGridObject(GridObjectEnum _test, string _testColour)
    {
        for (int row = 0; row < rows; row++)
        {
            for (int col = 0; col < cols; col++)
            {
                if(grid[col,row] == _test){
                    float posX = col * tileSize;
                    float posY = row * -tileSize;
                    GameObject test = (GameObject) Instantiate(Resources.Load(_testColour));
                    test.transform.position = new Vector2(posX,posY);
                }
            }
        }
    }

    public void GenerateGrid()
    {
        border = new int[borderAmount];
        grid = new GridObjectEnum[cols,rows];

        GenerateBorderIntervalArray();  // saves the border in an array to be compared to the GridManager.Instance.rows

        PutInTheStartBlocks();    // puts the names into the grid array at their row and col position

        GenerateShipwreck();

        GenerateFishInto();

        GenerateGridArrayWithObjects();   // puts the blocks into the blocklist at there grid position
    }

    private void GenerateBorderIntervalArray()
    {
        rowsPerArea = (int) rows/(borderAmount);   

        for(int i = 0; i < borderAmount-1; i++)
        {
            border[i] = rowsPerArea*(i+1);
        }
    }

    private void PutInTheStartBlocks()
    {
        int borderCount = 0;
        for (int row = 0; row < rows; row++)
        {
            for (int col = 0; col < cols; col++)
            { 
                if(row == border[borderCount] && col != 0){
                    if(col != 0 || col != cols-1)
                    {
                        AbstractBorderGeneration( col, row, borderCount);
                    }
                    if(col == cols-2)
                    {
                        borderCount++;
                    }
                }else if(col == 0 || col == cols-1 || row == rows-1 )
                {
                    AbstractWallsGeneration(col, row);
                }else 
                {
                    if(ChanceInAHundred(chanceSpawnStartBlock))
                    {
                        AbstractIsGridObjectGeneration(col, row, borderCount);
                    }
                }
            }
        }
        PopulateTheBlocksFurther();  
    }

    private void PopulateTheBlocksFurther()
    {
        float blockPercentige = 0;
        float blockCount = 0;

        while(blockPercentige < areaBlockPercent){
            List<int> colSave = new List<int>();
            List<int> rowSave = new List<int>();
            blockCount = 0;

            for (int row = 0; row < rows; row++)
            {
                for (int col = 0; col < cols; col++)
                {
                    if(((int) grid[col,row] >= 1 && (int) grid[col,row] < 999))
                    {
                        blockCount++; 
                        colSave.Add(col);
                        rowSave.Add(row);                      
                    }
                }
            }
            
            for(int i = 0; i < colSave.Count; i++)
            {
                PutSameGridObjectNextToThis(colSave[i],rowSave[i]);
            }

            blockPercentige = (blockCount / (rows * cols)) * 100;
        }

        for (int row = 0; row < rows; row++)
        {
            for (int col = 0; col < cols; col++)
            {
                if( grid[col,row] == GridObjectEnum.Air)
                {
                    IsThisAirGridObjectSurroundedByBlocks(col, row);
                }
            }
        }

    }

    private void IsThisAirGridObjectSurroundedByBlocks(int _col, int _row)
    {
        if(_col < 0 || _col > cols-1 || _row < 0 || _row > rows-1)
            return;
        
        bool topABlock = false;
        bool rightABlock = false;
        bool downABlock = false;
        bool leftABlock = false;
        GridObjectEnum tmpGridObject = GridObjectEnum.Air;

        if(_row != 0){
            if(((int) grid[_col,_row-1] >= 1 && (int) grid[_col,_row-1] < 999))
            {
                topABlock = true;
            }
        } else
        {
            topABlock = true;
        }

        if(_col != cols-1){
            if((int) grid[_col+1,_row] >= 1 && (int) grid[_col+1,_row] < 999)
            {
                rightABlock = true;
                tmpGridObject = grid[_col+1,_row]; 
            }
        } else
        {
            rightABlock = true;
        }

        if(_row != rows-1){
            if((int) grid[_col,_row+1] >= 1 && (int) grid[_col,_row+1] < 999)
            {
                downABlock = true;
            }
        } else
        {
            downABlock = true;
        }

        if(_col != 0){
            if((int) grid[_col-1,_row] >= 1 && (int) grid[_col-1,_row] < 999)
            {
                leftABlock = true;
                tmpGridObject = grid[_col-1,_row];
            }
        } else
        {
            leftABlock = true;
        }

        if(topABlock && rightABlock && downABlock && leftABlock)
        {
            grid[_col,_row] = tmpGridObject;
        }
    }

    public string WhatSidesAreBlocks(int _col, int _row, GridObjectEnum _gridObject)
    {
        if(_col < 0 || _col > cols-1 || _row < 0 || _row > rows-1)
            return "";
        
        string onWhichSidesAreBlocks = "";

        if(_row != 0){
            if((grid[_col,_row-1] == _gridObject))
            {
                onWhichSidesAreBlocks += "t";
            }
        }
        if(_col != cols-1){
            if( grid[_col+1,_row] == _gridObject)
            {
                onWhichSidesAreBlocks += "r";
            }
        }else
        {
            onWhichSidesAreBlocks += "r";
        }
        if(_row != rows-1){
            if( grid[_col,_row+1] == _gridObject)
            {
                onWhichSidesAreBlocks += "d";
            }
        }
        if(_col != 0){
            if( grid[_col-1,_row] == _gridObject)
            {
                onWhichSidesAreBlocks += "l";
            }
        }else
        {
            onWhichSidesAreBlocks += "l";
        }

        return onWhichSidesAreBlocks;
    }

    public string WhatCornersAreBlocks(int _col, int _row, GridObjectEnum _gridObject)
    {
        if(_col < 0 || _col > cols-1 || _row < 0 || _row > rows-1)
            return "";
        
        string onWhichSidesAreBlocks = "";

        if(_row != 0 && _col != 0){
            if( grid[_col-1,_row-1] == _gridObject)
            {
                onWhichSidesAreBlocks += "1";
            }
        }
        if(_col != cols-1 && _row != 0){
            if( grid[_col+1,_row-1] == _gridObject)
            {
                onWhichSidesAreBlocks += "2";
            }
        }
        if(_row != rows-1 && _col != cols-1 ){
            if( grid[_col+1,_row+1] == _gridObject)
            {
                onWhichSidesAreBlocks += "3";
            }
        }
        if(_col != 0 && _row != rows-1 ){
            if( grid[_col-1,_row+1] == _gridObject)
            {
                onWhichSidesAreBlocks += "4";
            }
        } 

        return onWhichSidesAreBlocks;
    }

    private void PutSameGridObjectNextToThis( int _col, int _row)
    {
        GridObjectEnum tmpgridObject = grid[_col,_row];
        if(_col < 0 || _col > cols-1 || _row < 0 || _row > rows-1)
            return;

        if(_row != 0){
            if(!((int) grid[_col,_row-1] >= 1 && (int) grid[_col,_row-1] < 999))
            {
                if(ChanceInAHundred(Random.Range(0,20)))
                {
                    grid[_col,_row-1] = tmpgridObject;
                }
            }
        }
        if(_col != cols-1){
            if(!((int) grid[_col+1,_row] >= 1 && (int) grid[_col+1,_row] < 999))
            {
                if(ChanceInAHundred(Random.Range(0,70)))
                {
                    grid[_col+1,_row] = tmpgridObject;
                }
            }
        }
        if(_row != rows-1){
            if(!((int) grid[_col,_row+1] >= 1 && (int) grid[_col,_row+1] < 999))
            {
                if(ChanceInAHundred(Random.Range(0,20)))
                {
                    grid[_col,_row+1] = tmpgridObject;
                }
            }
        }
        if(_col != 0){
            if(!((int) grid[_col-1,_row] >= 1 && (int) grid[_col-1,_row] < 999))
            {
                if(ChanceInAHundred(Random.Range(0,70)))
                {
                    grid[_col-1,_row] = tmpgridObject;
                }
            }
        }
    }

    private void AbstractBorderGeneration(int _col,int _row, int _bordercount)
    {
        if(_bordercount == 0)
        grid[_col,_row] = GridObjectEnum.Border1Object;
        if(_bordercount == 1)
        grid[_col,_row] = GridObjectEnum.Border2Object;
        if(_bordercount == 2)
        grid[_col,_row] = GridObjectEnum.Border3Object;
        if(_bordercount == 3)
        grid[_col,_row] = GridObjectEnum.Border4Object;
        if(_bordercount == 4)
        grid[_col,_row] = GridObjectEnum.Border5Object;
    }

    private void AbstractWallsGeneration(int _col, int _row)
    {
        if(_col == 0 )
            grid[_col,_row] = GridObjectEnum.MainBorder;
        if(_col == cols-1)
            grid[_col,_row] = GridObjectEnum.MainBorder;
        if(_row == rows-1)
            grid[_col,_row] = GridObjectEnum.Border5Object;              
    }

    private void AbstractIsGridObjectGeneration(int _col, int _row, float _bordercount)
    {
        grid[_col,_row] = GetGridObjectAccordingToBorderCount(_bordercount);
    }

    private GridObjectEnum GetGridObjectAccordingToBorderCount(float _bordercount)
    {
        GridObjectEnum _output; 
        switch(_bordercount)
        {
            case 1:
                _output = GridObjectEnum.Area2Object;
            break;
            case 2:
                _output = GridObjectEnum.Area3Object;
            break;
            case 3:
                _output = GridObjectEnum.Area4Object;
            break;
            case 4:
                _output = GridObjectEnum.Area5Object;
            break;
            default:
                _output = GridObjectEnum.Area1Object;
            break;
        }
        return _output;
    }

    public string WhereCanAnObjectSpawn(int _col, int _row)
    {
        string _output = "";
        if(_col < 0 || _col > cols-1 || _row < 0 || _row > rows-1)
            return _output;

        if(_row != 0){
            if(!((int) grid[_col,_row-1] >= 1 && (int) grid[_col,_row-1] < 999))
            {
                if(!((int) grid[_col,_row-1] >= 1101 && (int) grid[_col,_row-1] < 1105))
                {
                    _output = _output+ "t";
                }
                
            }
        }
        if(_col != cols-1){
            if(!((int) grid[_col+1,_row] >= 1 && (int) grid[_col+1,_row] < 999))
            {
                if(!((int) grid[_col+1,_row] >= 1101 && (int) grid[_col+1,_row] < 1105))
                {
                    _output = _output+ "r";
                }
            }
        }
        if(_row != rows-1){
            if(!((int) grid[_col,_row+1] >= 1 && (int) grid[_col,_row+1] < 999))
            {
                if(!((int) grid[_col,_row+1] >= 1101 && (int) grid[_col,_row+1] < 1105))
                {
                    _output = _output+ "b";
                }
                
            }
        }
        if(_col != 0){
            if(!((int) grid[_col-1,_row] >= 1 && (int) grid[_col-1,_row] < 999))
            {
                if(!((int) grid[_col-1,_row] >= 1101 && (int) grid[_col-1,_row] < 1105))
                {
                    _output = _output+ "l";
                }   
                
            }
        }
        return _output;
    }

    private void GenerateShipwreck()
    {
        float timer = 0;
        for (int row = border[1]; row < rows-2; row++)
        {
            for (int col = 1; col < cols-2; col++)
            { 
                if(grid[col,row] == GridObjectEnum.Air)
                {
                    timer++;
                    
                    if(CheckIfAreaFreeFor3x2Wreck(col,row))
                    {
                        if(ChanceInAHundred(chanceSpawn3x2Wreck))
                        {
                            
                            for(int i=0; i <3;i++)
                            {
                                grid[col+i,row] = GridObjectEnum.Wreck2;
                                grid[col+i,row+1] = GridObjectEnum.WreckBuild;
                            }
                        } 
                    }
                    if(CheckIfAreaFreeFor2x2Wreck(col,row))
                    {
                        if(ChanceInAHundred(chanceSpawn2x2Wreck))
                        {
                            for(int i=0; i <2;i++)
                            {
                                grid[col+i,row] = GridObjectEnum.Wreck1;
                                grid[col+i,row+1] = GridObjectEnum.WreckBuild;
                            }
                        }
                    }
                }
            }
        }
    }

    private bool CheckIfAreaFreeFor3x2Wreck(int _col, int _row)
    {
        bool _output = true;
        int areaX = 3;
        int areaY = 2;

        if(_col >= cols-areaX || _row >= rows-areaY)
        {
            return false;
        }

        for(int i=0; i <areaX;i++)
        {
            for(int l=0;l <areaY;l++)
            {
                if(grid[_col+i,_row+l] != GridObjectEnum.Air)
                {
                    _output = false;
                }
            }
            if(!((int)grid[_col+i, _row+2] >= 1 && (int)grid[_col+i, _row+2] < 999)){
                _output = false;
            }
        }
        return _output;
    }

    private bool CheckIfAreaFreeFor2x2Wreck(int _col, int _row)
    {
        bool _output = true;
        int areaX = 2;
        int areaY = 2;

        if(_col >= cols-areaX || _row >= rows-areaY)
        {
            return false;
        }
        for(int i=0; i <areaX;i++)
        {
            for(int l=0;l <areaY;l++)
            {
                if(grid[_col+i,_row+l] != GridObjectEnum.Air)
                {
                    _output = false;
                }
            }
            if(!((int)grid[_col+i, _row+2] >= 1 && (int)grid[_col+i, _row+2] < 999)){
                _output = false;
            }
        }
        return _output;
    }

    private void GenerateGridArrayWithObjects()
    {
        int blockIndex = 0;
        int fishIndex = 0;
        

        for (int row = 0; row < rows; row++)
        {
            for (int col = 0; col < cols; col++)
            { 
                if(row == 0)
                {
                    if(PlayerStartAreaBlock(new Vector2(col,row)))
                    {
                        grid[col,row] = GridObjectEnum.Air;
                    }
                }
                if((int) grid[col,row] >= 2000 && (int) grid[col,row] < 2999)
                {
                    PutFishIntoGrid(col, row, fishIndex);
                    fishIndex++;
                }
                if((int) grid[col,row] >= 1 && (int) grid[col,row] < 999)
                {
                    PutGridObjectsIntoGrid(col, row, blockIndex);
                    blockIndex++;
                }
            }
        }  
        for (int row = 0; row < rows; row++)
        {
            for (int col = 0; col < cols; col++)
            { 
                if(grid[col,row] == GridObjectEnum.Wreck1)
                {
                    Put2x2WreckIntoGrid(col, row);
                }
                if(grid[col,row] == GridObjectEnum.Wreck2)
                {
                    Put3x2WreckIntoGrid(col, row);
                }
            }
        }
    }

    private bool PlayerStartAreaBlock(Vector2 _colRow)
    {
        bool _output = false;
        int gridWidth = GridManagerStats.Instance.cols;
        int gridWidthHalf = (int) gridWidth/2;
        for(int i = gridWidthHalf-2;i < gridWidthHalf+2;i++)
        {
            if(_colRow == new Vector2(i,0))
            {
                _output = true;
            }
        }
        return _output;
    }

    private void Put2x2WreckIntoGrid(int _col, int _row)
    {
        grid[_col,_row] = GridObjectEnum.WreckBuild;
        grid[_col+1,_row] = GridObjectEnum.WreckBuild;
        GameObject shipWreck = (GameObject) Instantiate(Resources.Load(Wreck2x2Prefab));
        shipWreck.GetComponent<ShipWreckSkin>().PutInfosIntoPrefab(new Vector2(_col,_row));
        
        float deviation = 0.5f;
        float posX = (_col ) * tileSize+ deviation ;
        float posY = (_row ) * -tileSize - deviation*2 ;
        shipWreck.transform.position = new Vector2(posX,posY);
        PutChestInto2x2Wreck(_col,_row+1);
    }

    private void Put3x2WreckIntoGrid(int _col, int _row)
    {
        for(int i=0; i <3;i++)
        {
            grid[_col+i,_row] = GridObjectEnum.WreckBuild;
        }
        GameObject shipWreck = (GameObject) Instantiate(Resources.Load(Wreck3x2Prefab));
        shipWreck.GetComponent<ShipWreckSkin>().PutInfosIntoPrefab(new Vector2(_col,_row));
        
        float deviation = 1f;
        float posX = (_col ) * tileSize+ deviation ;
        float posY = (_row ) * -tileSize - deviation ;
        shipWreck.transform.position = new Vector2(posX,posY);
        PutChestInto3x2Wreck(_col,_row+1);
    }

    private void PutChestInto2x2Wreck(int _col, int _row)
    {
        int _random = (int) Random.Range(0,100);

        float posX = _col * tileSize;
        float posY = _row  * -tileSize-0.1f;
        if(_random >= 0 && _random <= chanceSpawnSingleChest)
        {
            GameObject _singleChest = (GameObject) Instantiate(Resources.Load(singleChest));
            int _randomLeftorRightChest = (int) Random.Range(0,2);
            
            posX = (_col +_randomLeftorRightChest) *tileSize ;
            _singleChest.transform.position = new Vector2(posX,posY); 
            grid[_col+_randomLeftorRightChest,_row] = GridObjectEnum.Chest1;
        }else{
            GameObject _doubleChest = (GameObject) Instantiate(Resources.Load(doubleChest));
            posX = (_col +0.5f) *tileSize ;
            _doubleChest.transform.position = new Vector2(posX,posY);
            grid[_col+1,_row] = GridObjectEnum.Chest1;
            grid[_col,_row] = GridObjectEnum.Chest1;
        }
    }

    private void PutChestInto3x2Wreck(int _col, int _row)
    {
        int _random = (int) Random.Range(0,100);

        float posX = _col * tileSize;
        float posY = _row  * -tileSize-0.1f;
        
        GameObject _doubleChest = (GameObject) Instantiate(Resources.Load(doubleChest));
        int _randomLeftorRightChest = (int) Random.Range(0,2);

        posX = (_col +0.5f+ _randomLeftorRightChest) *tileSize ;
        _doubleChest.transform.position = new Vector2(posX,posY);
        grid[_col+_randomLeftorRightChest,_row] = GridObjectEnum.Chest1;
        grid[_col+_randomLeftorRightChest+1,_row] = GridObjectEnum.Chest1;
    }

    public int InWhichBorderIsThisRow(int _row)
    {
        int _rowAbs = Mathf.Abs(_row);
        int whichBorder = 0;
        if(_rowAbs > 0 && _rowAbs < rows)
        {
            for(int i = 0; i < borderAmount-1; i++)
            {
                if(_rowAbs > border[i] && _rowAbs <= border[i+1])
                {
                    whichBorder = i +1;
                }
            }
        if(_rowAbs > border[borderAmount-2])
            whichBorder = borderAmount-1;
        }
        return whichBorder;
    }

    private void GenerateFishInto()
    {
        int borderCount;
        for (int row = 0; row < rows; row++)
        {
            for (int col = 0; col < cols; col++)
            { 
                
                if(CheckIfAreaFreeFor3x3(col,row) && ChanceInAHundred(chanceSpawnAFish))
                {
                    borderCount = InWhichBorderIsThisRow(row);
                    if(borderCount > 0)
                    {
                        
                        grid[col,row] = GetFishAccordingToBorderCount(borderCount);
                    }  
                    
                }
                if(CheckIfAreaFreeFor2x2(col,row) && ChanceInAHundred(chanceSpawnAFish))
                {
                    grid[col,row] = GridObjectEnum.SmallFish;
                }
            }
        }
    }

    public void PutFishIntoGrid(int _col, int _row, int _index)
    {
        float posX = _col * tileSize;
        float posY = _row * -tileSize;
        fishOverview.AddFishIntoObjectList(new Vector2(posX,posY), grid[_col,_row],_index);
    }

    public void PutGridObjectsIntoGrid(int _col, int _row, int _index)
    {
        float posX = _col * tileSize;
        float posY = _row * -tileSize;
        BlockOverview.Instance.AddTileToGridObjectList(new Vector2Int(_col,_row),new Vector2(posX,posY),grid[_col,_row],_index,WhereCanAnObjectSpawn(_col,_row)); 
    }

    private GridObjectEnum GetFishAccordingToBorderCount(float _bordercount)
    {
        GridObjectEnum _output; 
        switch(_bordercount)
        {
            default:
                _output = GridObjectEnum.SmallFish;
            break;
            case 1:                
                if(ChanceInAHundred(smallFishSpawn))
                {
                    _output = GridObjectEnum.SmallFish;
                }
                else
                {
                    _output = GridObjectEnum.MediumFish;              
                }
            break;
            case 2:                
                    _output = GridObjectEnum.MediumFish;
            break;
            case 3:                
                if(ChanceInAHundred(mediumFishSpawn))
                {
                    _output = GridObjectEnum.MediumFish;
                }
                else
                {
                    _output = GridObjectEnum.BigFish;
                }
            break;
            case 4:
                if(ChanceInAHundred(bigFishSpawn))
                {
                    _output = GridObjectEnum.BigFish;
                }
                else
                {
                    _output = GridObjectEnum.MediumFish;
                }
            break;
        }
        return _output;
    }

    private bool CheckIfAreaFreeFor2x2(int _col, int _row)
    {
        bool _output = true;
        int areaX = 2;
        int areaY = 2;

        if(_col >= cols-areaX || _row >= rows-areaY)
        {
            return false;
        }

        for(int i=0; i <areaY;i++)
        {
            for(int l=0; l <areaX;l++)
            {
                if(grid[_col+l,_row+i] != GridObjectEnum.Air)
                {
                    _output = false;
                }
            }
        }
        return _output;
    }

    private bool CheckIfAreaFreeFor3x3(int _col, int _row)
    {
        bool _output = true;
        int areaX = 3;
        int areaY = 3;

        if(_col >= cols-areaX || _row >= rows-areaY)
        {
            return false;
        }

        for(int i=0; i <areaY;i++)
        {
            for(int l=0; l <areaX;l++)
            {
                if(grid[_col+l,_row+i] != GridObjectEnum.Air)
                {
                    _output = false;
                }
            }
        }
        return _output;
    }

    public bool ChanceInAHundred(float _chanceToHit)
    {
        float _objectChance = Random.Range(0,100f);
        if(_objectChance < _chanceToHit){
            return true;
        }
        return false;
    }
}

