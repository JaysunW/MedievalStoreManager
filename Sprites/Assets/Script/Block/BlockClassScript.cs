using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BlockClassScript : MonoBehaviour
{
    [HideInInspector]
    public int[] area1SpawnChance;
    [HideInInspector]
    public int[] area2SpawnChance;
    [HideInInspector]
    public int[] area3SpawnChance;
    [HideInInspector]
    public int[] area4SpawnChance;
    [HideInInspector]
    public int[] area5SpawnChance;

    public GameObject [] coralGameObject;
    private static string [] coralGameObjectNames;

    public int _shellLength;
    public static int shellLength;

    private string area1Object = "Blocks/Area1Object";
    private string area2Object = "Blocks/Area2Object";
    private string area3Object = "Blocks/Area3Object";
    private string area4Object = "Blocks/Area4Object";
    private string area5Object = "Blocks/Area5Object";

    private string area1ObjectBorder = "Blocks/Border1Object";
    private string area2ObjectBorder = "Blocks/Border2Object";
    private string area3ObjectBorder = "Blocks/Border3Object";
    private string area4ObjectBorder = "Blocks/Border4Object";
    private string area5ObjectBorder = "Blocks/Border5Object";

    private string area1ObjectDrop = "Drops/Drop1";
    private string area2ObjectDrop = "Drops/Drop2";
    private string area3ObjectDrop = "Drops/Drop3";
    private string area4ObjectDrop = "Drops/Drop4";
    private string area5ObjectDrop = "Drops/Drop5";
    

    public List<BlockClass> cells = new List<BlockClass>();


    public void Start()
    {
        coralGameObjectNames = new string [coralGameObject.Length];
        PopulateCoralNamesArray();
        shellLength = _shellLength;
        BlockOverview.Instance.SetBlockClass(this.gameObject.GetComponent<BlockClassScript>());
    }

    public void PopulateCoralNamesArray()
    {
        for(int i = 0; i < coralGameObjectNames.Length; i++)
        {
            coralGameObjectNames[i] = coralGameObject[i].name;
        }
    }

    public void AddToGridList(Vector2Int _colRow, Vector2 _blockPosition, GridObjectEnum _name, int _index, string _sidesForObjects)
    {
        switch(_name)
            {
                case GridObjectEnum.MainBorder:
                    cells.Add(new MainBorder(_colRow,_blockPosition,_name,_index,_sidesForObjects));  
                break;
                case GridObjectEnum.Area1Object:
                    cells.Add(new Area1Object(_colRow,_blockPosition,area1Object,_name,_index,area1SpawnChance[0],area1SpawnChance[1],area1SpawnChance[2],area1ObjectDrop,BlockOverview.Instance.area1ObjectValue,_sidesForObjects));  
                break;
                case GridObjectEnum.Area2Object:
                    cells.Add(new Area2Object(_colRow,_blockPosition,area2Object,_name,_index,area2SpawnChance[0],area2SpawnChance[1],area2SpawnChance[2],area2ObjectDrop,BlockOverview.Instance.area2ObjectValue,_sidesForObjects));  
                break;
                case GridObjectEnum.Area3Object:
                    cells.Add(new Area3Object(_colRow,_blockPosition,area3Object,_name,_index,area3SpawnChance[0],area3SpawnChance[1],area3SpawnChance[2],area3ObjectDrop,BlockOverview.Instance.area3ObjectValue,_sidesForObjects));
                break;
                case GridObjectEnum.Area4Object:
                    cells.Add(new Area4Object(_colRow,_blockPosition,area4Object,_name,_index,area4SpawnChance[0],area4SpawnChance[1],area4SpawnChance[2],area4ObjectDrop,BlockOverview.Instance.area4ObjectValue,_sidesForObjects)); 
                break;
                case GridObjectEnum.Area5Object:
                    cells.Add(new Area4Object(_colRow,_blockPosition,area5Object,_name,_index,area5SpawnChance[0],area5SpawnChance[1],area5SpawnChance[2],area5ObjectDrop,BlockOverview.Instance.area5ObjectValue,_sidesForObjects)); 
                break;
                case GridObjectEnum.Border1Object:
                    cells.Add(new Border1Object(_colRow,_blockPosition,area1ObjectBorder,_name,_index,area1SpawnChance[0],area1SpawnChance[1],area1SpawnChance[2],area1ObjectDrop,BlockOverview.Instance.area1ObjectValue,_sidesForObjects,1));
                break;
                case GridObjectEnum.Border2Object:
                    cells.Add(new Border2Object(_colRow,_blockPosition,area2ObjectBorder,_name,_index,area2SpawnChance[0],area2SpawnChance[1],area2SpawnChance[2],area2ObjectDrop,BlockOverview.Instance.area2ObjectValue,_sidesForObjects,2));
                break;
                case GridObjectEnum.Border3Object:
                    cells.Add(new Border3Object(_colRow,_blockPosition,area3ObjectBorder,_name,_index,area3SpawnChance[0],area3SpawnChance[1],area3SpawnChance[2],area3ObjectDrop,BlockOverview.Instance.area3ObjectValue,_sidesForObjects,3));
                break;
                case GridObjectEnum.Border4Object:
                    cells.Add(new Border4Object(_colRow,_blockPosition,area4ObjectBorder,_name,_index,area4SpawnChance[0],area4SpawnChance[1],area4SpawnChance[2],area4ObjectDrop,BlockOverview.Instance.area4ObjectValue,_sidesForObjects,4));
                break;
                case GridObjectEnum.Border5Object:
                    cells.Add(new Border5Object(_colRow,_blockPosition,area5ObjectBorder,_name,_index,area5SpawnChance[0],area5SpawnChance[1],area5SpawnChance[2],area5ObjectDrop,BlockOverview.Instance.area5ObjectValue,_sidesForObjects,4));
                break;
            }
    }

    public abstract class BlockClass     // the main class with the things all blocks have
    {
        public GameObject tile;     // the gameObject reference
        public Vector2 blockPosition;   // position in the world
        public Vector2Int colRow;  // position in grid row and col
        public GridObjectEnum name;  // what type of block it is
        public int index;    // its place in the array

        public int chanceToDropSomethingSpecial;

        public int gemSpawn;
        public int juwelSpawn;
        public string dropName;

        public int value;

        public LayerMask blockMask = 1<<8;

        public string sidesForObjects;
        public float sizeOfSideObject = GridManagerStats.Instance.tileSize*0.8f;

        public GameObject coralObject;
    
        public GameObject shellObject;

        private string coralResourceSource = "Coral/";
        private string shellResourceSource = "Shell/Shell";
        public string[] specialDrops = new string [] { "Gem", "Juwel"};

        public string[] coral = new string[coralGameObjectNames.Length];
        public string[] shell = new string[shellLength];

        public abstract void DestroyBlock();

        public void PopulateCoral()
        {
            for(int i = 0; i < coral.Length;i++)
            {
                coral[i] = coralResourceSource + coralGameObjectNames[i];
            }
        }

        public void PopulateShell()
        {
            for(int i = 0; i < shell.Length;i++)
            {
                shell[i] = shellResourceSource + i.ToString();
            }
        }

        public void ChangeSizeToTileSize()
        {
            this.tile.transform.localScale = new Vector2(GridManagerStats.Instance.tileSize,GridManagerStats.Instance.tileSize);
        }

        public void MoveTileToItsPosition()  // put every block at its own place
        {
            this.tile.transform.position = blockPosition;
        }

        public void SpawnCoral()
        {
            if(SideToSpawnObject() != '\0')
                PutCoralOnTheSide(SideToSpawnObject());
        }

        public void SpawnShell()
        {
            if(SideToSpawnObject() != '\0')
                PutShellOnTheSide(SideToSpawnObject());
        }

        public char SideToSpawnObject()
        {   
            int stringVarLength = this.sidesForObjects.Length;
            if(stringVarLength > 0)
            {
                int chosenSide = Random.Range(0,stringVarLength);
                char spawnSide = sidesForObjects[chosenSide];
                return spawnSide;
            }
            return '\0';
        }

        private void PutCoralOnTheSide(char _t)
        { 
            coralObject = WhichCoralGetsSpawned();
            
            if(coralObject != null)
            {
                SetCoralInfos(coralObject, _t);
                coralObject.transform.localScale = new Vector2(sizeOfSideObject,sizeOfSideObject);
                PositioningAndRotaingOfObjectToChar(coralObject, _t);
            }     
        }

        private void PutShellOnTheSide(char _t)
        { 
            shellObject = WhichShellGetsSpawned();

            if(shellObject != null)
            {
                SetShellInfos(shellObject, _t);
                shellObject.transform.localScale = new Vector2(sizeOfSideObject,sizeOfSideObject);
                PositioningAndRotaingOfObjectToChar(shellObject, _t);
            }     
        }

        private GameObject WhichCoralGetsSpawned()
        {   
            GameObject _gameObject = null;
            if(GridManagerStats.Instance.InWhichBorderIsThisRow(colRow.y) < coral.Length)
            {
                _gameObject = (GameObject) Instantiate(Resources.Load(coral[Random.Range(0,coral.Length)]));
            }
            return _gameObject;
        }

        private GameObject WhichShellGetsSpawned()
        {
            GameObject _gameObject = null;
            if(GridManagerStats.Instance.InWhichBorderIsThisRow(colRow.y) < shell.Length)
            {
                _gameObject = (GameObject) Instantiate(Resources.Load(shell[GridManagerStats.Instance.InWhichBorderIsThisRow(colRow.y)]));
            }else
            {
                _gameObject = (GameObject) Instantiate(Resources.Load(shell[Random.Range(0,shell.Length)]));
            }
            return _gameObject; 
        }

        private void SetCoralInfos(GameObject _coralObject, char _t)
        {
            CoralInfo _coralInfo = _coralObject.GetComponent<CoralInfo>();
            _coralInfo.SetInfos(_t);
        }

        private void SetShellInfos(GameObject _shellObject, char _t)
        {
            ShellInfo _shellInfo = _shellObject.GetComponent<ShellInfo>();
            _shellInfo.SetInfos(_t);
        }

        private void PositioningAndRotaingOfObjectToChar(GameObject _object, char _i)
        {
            float distanceBetweenBlockAndObject = sizeOfSideObject/2 - 0.05f + GridManagerStats.Instance.tileSize/2;
            switch(_i)
            {
                case 't':
                    _object.transform.position = blockPosition + new Vector2(0,distanceBetweenBlockAndObject);
                break;
                case 'r':
                    _object.transform.position = blockPosition + new Vector2(distanceBetweenBlockAndObject,0);
                    RotateGameObject(_object, -90);
                break;
                case 'b':
                    _object.transform.position = blockPosition + new Vector2(0,-distanceBetweenBlockAndObject);
                    RotateGameObject(_object, 180);
                break;
                case 'l':
                    _object.transform.position = blockPosition + new Vector2(-distanceBetweenBlockAndObject,0);
                    RotateGameObject(_object, 90);
                break;
            }
        }

        private void RotateGameObject(GameObject _gameObject, int _degrees)
        {
            _gameObject.transform.rotation = Quaternion.Euler(Vector3.forward * _degrees);
        }

        private bool FindSpecificLetterInString(char _j, string _specificString)
        {
            for(int i = 0; i < _specificString.Length; i++)
            {
                if(_specificString[i] == _j)
                    return true;
            }
            return false;
        }
    }

    public class BreakableBlock: BlockClass
    {

        public void FirstThingsToDoBreakable()
        {
            PopulateCoral();
            PopulateShell();
            ChangeSizeToTileSize();
            MoveTileToItsPosition();    // moves all blocks into position
            GiveBlockInfoTheIndex();    // gives every block except the walls their own index

            if(BlockOverview.Instance.ChanceInAHundred(GridManagerStats.Instance.chanceSpawnCoral))
                SpawnCoral();
            if(BlockOverview.Instance.ChanceInAHundred(GridManagerStats.Instance.chanceSpawnShell))
                SpawnShell();
        }

        public void GiveBlockInfoTheIndex()     // gives the blockInfo script its index
        {
            BlockInfo _blockInfo = this.tile.GetComponent<BlockInfo>();
            _blockInfo.SetIndex(this.index);
            _blockInfo.SetGridPosition(this.colRow);
        }

        public override void DestroyBlock() // if the block has no health its destroyed and drops things
        {
            if(BlockOverview.Instance.ChanceInAHundred(chanceToDropSomethingSpecial))
            {
                WhichSpecialThingGetsDropped();
            }
            DropIndividualItem();
            RemoveBlockFromGrid();
            DestroyObjectsOnBlock();
            UpdateSpritesOfBlocksAround();
            Destroy(this.tile);
        }
       
        private void UpdateSpritesOfBlocksAround()
        {
            Collider2D topObject = Physics2D.OverlapCircle(this.blockPosition + Vector2.up, 0.1f, blockMask);
            if(topObject != null && topObject.transform.gameObject.GetComponent<BlockInfo>() != null)
            {
                UpdateSpriteOfBlock(topObject);
            }
            Collider2D rightObject = Physics2D.OverlapCircle(this.blockPosition + Vector2.right, 0.1f, blockMask);
            if(rightObject != null && rightObject.transform.gameObject.GetComponent<BlockInfo>() != null)
            {
                UpdateSpriteOfBlock(rightObject);
            }
            Collider2D downObject = Physics2D.OverlapCircle(this.blockPosition + Vector2.down, 0.1f, blockMask);
            if(downObject != null && downObject.transform.gameObject.GetComponent<BlockInfo>() != null)
            {
                UpdateSpriteOfBlock(downObject);
            }
            Collider2D leftObject = Physics2D.OverlapCircle(this.blockPosition + Vector2.left, 0.1f, blockMask);
            if(leftObject != null && leftObject.transform.gameObject.GetComponent<BlockInfo>() != null)
            {
                UpdateSpriteOfBlock(leftObject);
            }
            Collider2D topLeftObject = Physics2D.OverlapCircle(this.blockPosition + new Vector2(-1,1), 0.1f, blockMask);
            if(topLeftObject != null && topLeftObject.transform.gameObject.GetComponent<BlockInfo>() != null)
            {
                UpdateSpriteOfBlock(topLeftObject);
            }
            Collider2D topRightObject = Physics2D.OverlapCircle(this.blockPosition + new Vector2(1,1), 0.1f, blockMask);
            if(topRightObject != null && topRightObject.transform.gameObject.GetComponent<BlockInfo>() != null)
            {
                UpdateSpriteOfBlock(topRightObject);
            }
            Collider2D downRightObject = Physics2D.OverlapCircle(this.blockPosition + new Vector2(1,-1), 0.1f, blockMask);
            if(downRightObject != null && downRightObject.transform.gameObject.GetComponent<BlockInfo>() != null)
            {
                UpdateSpriteOfBlock(downRightObject);
            }
            Collider2D downLeftObject = Physics2D.OverlapCircle(this.blockPosition + new Vector2(-1,-1), 0.1f, blockMask);
            if(downLeftObject != null && downLeftObject.transform.gameObject.GetComponent<BlockInfo>() != null)
            {
                UpdateSpriteOfBlock(downLeftObject);
            }
        }

        private void UpdateSpriteOfBlock(Collider2D _object)
        {
            _object.transform.gameObject.GetComponent<BlockInfo>().UpdateBlockSprite();
        }

        private void WhichSpecialThingGetsDropped()     // handels which specialDrop gets dropped
        {
            float _objectChance = Random.Range(0,100f);
            
            if(_objectChance >= 0 && _objectChance < gemSpawn)
            {
                DropSpecialThing(0);
            }
            else
            {
                DropSpecialThing(1);
            }
        } 

        private void DropSpecialThing(int i)
        {
            GameObject loot = (GameObject) Instantiate(Resources.Load(specialDrops[i]));
            loot.transform.position = this.blockPosition;
        }

        private void DropIndividualItem()
        {
            GameObject _drop = CreateDropGameObject();
            GiveDropPositionAndInfo(_drop);
        }

        private void RemoveBlockFromGrid()
        {
            GridManagerStats.Instance.grid[colRow.x,colRow.y] = GridObjectEnum.Air;
        }

        private void DestroyObjectsOnBlock()
        {
            if(this.coralObject != null)
            {
                CoralInfo _coralInfo = coralObject.GetComponent<CoralInfo>();
                Vector2Int _coralColRow = _coralInfo.GetColRow();
                _coralInfo.ChangeGridValueWhereTheCoralWas(_coralColRow);
                Destroy(this.coralObject);
            }

            if(this.shellObject != null)
            {
                ShellInfo _shellInfo = shellObject.GetComponent<ShellInfo>();
                Destroy(this.shellObject);
            }
        }

        private GameObject CreateDropGameObject()
        {
            GameObject drop = (GameObject) Instantiate(Resources.Load(dropName));
            return drop;
        }

        private void GiveDropPositionAndInfo(GameObject _drop)
        {
            _drop.transform.position = blockPosition;
            DropBehaviourFromBlock dropBehaviour = _drop.GetComponent<DropBehaviourFromBlock>();
            dropBehaviour.GetInfo(name, value + Random.Range(-5,5));
        }

    }

    public class UnbreakableBlock : BlockClass
    {
        public void FirstThingsToDoUnbreakable()
        {
            PopulateCoral();
            PopulateShell();
            ChangeSizeToTileSize();
            MoveTileToItsPosition();    // moves all blocks into position
            this.tile.GetComponent<BorderSkinChange>().SetColRow(this.colRow);

            if(BlockOverview.Instance.ChanceInAHundred(GridManagerStats.Instance.chanceSpawnCoral))
                SpawnCoral();
            if(BlockOverview.Instance.ChanceInAHundred(GridManagerStats.Instance.chanceSpawnShell))
                SpawnShell();
        }

        public override void DestroyBlock() // if the block has no health its destroyed and drops things
        {
            return;
        }
    }

    public class AreaObject : BreakableBlock
    {
        public AreaObject(Vector2Int _colRow,Vector2 _blockPosition,string _resourceObject, GridObjectEnum _name,int _index, int _chanceSpawnSpecial, int _gemSpawn, int _juwelSpawn, string _dropName, int _value, string _sidesForObjects)
        {
            this.colRow = _colRow;
            this.blockPosition = _blockPosition;
            this.name = _name;
            this.index = _index;

            this.chanceToDropSomethingSpecial = _chanceSpawnSpecial;

            this.gemSpawn = _gemSpawn;
            this.juwelSpawn =  _juwelSpawn;
            this.dropName = _dropName;

            this.value = _value;
            this.sidesForObjects = _sidesForObjects;
            this.tile = (GameObject) Instantiate(Resources.Load(_resourceObject));

            FirstThingsToDoBreakable();
        }      
    }

    public class BorderObject : BreakableBlock
    {
        public int tier;

        public BorderObject(Vector2Int _colRow,Vector2 _blockPosition,string _resourceObject, GridObjectEnum _name,int _index, int _chanceSpawnSpecial, int _gemSpawn, int _juwelSpawn, string _dropName, int _value, string _sidesForObjects, int _tier)
        {
            this.colRow = _colRow;
            this.blockPosition = _blockPosition;
            this.name = _name;
            this.index = _index;

            this.chanceToDropSomethingSpecial = _chanceSpawnSpecial;

            this.gemSpawn = _gemSpawn;
            this.juwelSpawn =  _juwelSpawn;
            this.dropName = _dropName;

            this.value = _value;
            this.sidesForObjects = _sidesForObjects;
            this.tier = _tier;
            this.tile = (GameObject) Instantiate(Resources.Load(_resourceObject));

            SetBlockTier();
            FirstThingsToDoBreakable();
        }      

        private void SetBlockTier()
        {
            BlockInfo _blockInfo = this.tile.GetComponent<BlockInfo>();
            _blockInfo.SetTier(this.tier);
        }
    }

    class MainBorder : UnbreakableBlock
    {
        public MainBorder(Vector2Int _colRow,Vector2 _blockPosition, GridObjectEnum _name,int _index, string _sidesForObjects)
        {
            this.colRow = _colRow;
            this.blockPosition = _blockPosition;
            this.name = _name;
            this.index = _index;
            this.tile = (GameObject) Instantiate(Resources.Load("MainBorder"));
            this.sidesForObjects = _sidesForObjects;
            FirstThingsToDoUnbreakable();
        }      
    }

    public class Area1Object : AreaObject
    {
        public Area1Object(Vector2Int _colRow, Vector2 _blockPosition,string _resourceObject, GridObjectEnum _name,int _index, int _chanceSpawnSpecial, int _gemSpawn, int _juwelSpawn, string _dropName, int _value, string _sidesForObjects)
           : base(_colRow,_blockPosition,_resourceObject,_name,_index,_chanceSpawnSpecial,_gemSpawn,_juwelSpawn,_dropName,_value,_sidesForObjects)
        { 
        }      
    }

    public class Area2Object : AreaObject
    {
        public Area2Object(Vector2Int _colRow,Vector2 _blockPosition,string _resourceObject, GridObjectEnum _name,int _index, int _chanceSpawnSpecial, int _gemSpawn, int _juwelSpawn, string _dropName, int _value, string _sidesForObjects)
            : base(_colRow,_blockPosition,_resourceObject,_name,_index,_chanceSpawnSpecial,_gemSpawn,_juwelSpawn,_dropName,_value,_sidesForObjects)
        {
        }      
    }

    public class Area3Object : AreaObject
    {
        public Area3Object(Vector2Int _colRow,Vector2 _blockPosition,string _resourceObject, GridObjectEnum _name,int _index, int _chanceSpawnSpecial, int _gemSpawn, int _juwelSpawn, string _dropName, int _value, string _sidesForObjects)
            : base(_colRow,_blockPosition,_resourceObject,_name,_index,_chanceSpawnSpecial,_gemSpawn,_juwelSpawn,_dropName,_value,_sidesForObjects)
        {
        }      
    }

    public class Area4Object : AreaObject
    {
        public Area4Object(Vector2Int _colRow,Vector2 _blockPosition,string _resourceObject, GridObjectEnum _name,int _index, int _chanceSpawnSpecial, int _gemSpawn, int _juwelSpawn, string _dropName, int _value, string _sidesForObjects)
            : base(_colRow,_blockPosition,_resourceObject,_name,_index,_chanceSpawnSpecial,_gemSpawn,_juwelSpawn,_dropName,_value,_sidesForObjects)
        {
        }      
    }

    public class Area5Object : AreaObject
    {
        public Area5Object(Vector2Int _colRow,Vector2 _blockPosition,string _resourceObject, GridObjectEnum _name,int _index, int _chanceSpawnSpecial, int _gemSpawn, int _juwelSpawn, string _dropName, int _value, string _sidesForObjects)
            : base(_colRow,_blockPosition,_resourceObject,_name,_index,_chanceSpawnSpecial,_gemSpawn,_juwelSpawn,_dropName,_value,_sidesForObjects)
        {
        }      
    }

    public class Border1Object : BorderObject
    {
        public Border1Object(Vector2Int _colRow,Vector2 _blockPosition,string _resourceObject, GridObjectEnum _name,int _index, int _chanceSpawnSpecial, int _gemSpawn, int _juwelSpawn, string _dropName, int _value, string _sidesForObjects,int _tier)
            : base(_colRow,_blockPosition,_resourceObject,_name,_index,_chanceSpawnSpecial,_gemSpawn,_juwelSpawn,_dropName,_value,_sidesForObjects,_tier)
        {
        }      
    }

    public class Border2Object : BorderObject
    {
        public Border2Object(Vector2Int _colRow,Vector2 _blockPosition,string _resourceObject, GridObjectEnum _name,int _index, int _chanceSpawnSpecial, int _gemSpawn, int _juwelSpawn, string _dropName, int _value, string _sidesForObjects,int _tier)
            : base(_colRow,_blockPosition,_resourceObject,_name,_index,_chanceSpawnSpecial,_gemSpawn,_juwelSpawn,_dropName,_value,_sidesForObjects,_tier)
        {
        }      
    }

    public class Border3Object : BorderObject
    {
        public Border3Object(Vector2Int _colRow,Vector2 _blockPosition,string _resourceObject, GridObjectEnum _name,int _index, int _chanceSpawnSpecial, int _gemSpawn, int _juwelSpawn, string _dropName, int _value, string _sidesForObjects,int _tier)
            : base(_colRow,_blockPosition,_resourceObject,_name,_index,_chanceSpawnSpecial,_gemSpawn,_juwelSpawn,_dropName,_value,_sidesForObjects,_tier)
        {
        }      
    }

    public class Border4Object : BorderObject
    {
        public Border4Object(Vector2Int _colRow,Vector2 _blockPosition,string _resourceObject, GridObjectEnum _name,int _index, int _chanceSpawnSpecial, int _gemSpawn, int _juwelSpawn, string _dropName, int _value, string _sidesForObjects,int _tier)
            : base(_colRow,_blockPosition,_resourceObject,_name,_index,_chanceSpawnSpecial,_gemSpawn,_juwelSpawn,_dropName,_value,_sidesForObjects,_tier)
        {
        }      
    }

    public class Border5Object : BorderObject
    {
        public Border5Object(Vector2Int _colRow,Vector2 _blockPosition,string _resourceObject, GridObjectEnum _name,int _index, int _chanceSpawnSpecial, int _gemSpawn, int _juwelSpawn, string _dropName, int _value, string _sidesForObjects,int _tier)
            : base(_colRow,_blockPosition,_resourceObject,_name,_index,_chanceSpawnSpecial,_gemSpawn,_juwelSpawn,_dropName,_value,_sidesForObjects,_tier)
        {
        }      
    }
}
