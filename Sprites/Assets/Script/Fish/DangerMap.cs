using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DangerMap : MonoBehaviour
{
    public FishStats fishStats;
    public FishMove fishMove;
    public Collider2D thisCollider;

    private List<RaycastHit2D> dangerObjects = new List<RaycastHit2D>();

    private int rayCasted = 16;
    private float [] danger = new float[16];
    private Vector2 [] raycastVector2 = new Vector2[16];

    public float RaycastRange = 1;

    private List<int> index = new List<int>();
    private List<float> magnitude = new List<float>();

    private LayerMask layerMask;
    public LayerMask attackModeLayer;
    public LayerMask normalModeLayer;

    private void Start()
    {
        PopulateRaycastVector2Array();
        layerMask = normalModeLayer;
    }

    public void ChangeMode(string _mode)
    {
        if(_mode.Equals("attack"))
        {
            layerMask = attackModeLayer;
        }else if(_mode.Equals("normal"))
        {
            layerMask = normalModeLayer;
        }
    }

    private void PopulateRaycastVector2Array()
    {
        int _timer = 0;
        for(int i = -2; i <= 2; i++)
        {
            for(int j = 2; j >= -2; j--)
            {
                if(!((Mathf.Abs(i) + Mathf.Abs(j) == 0) ||(Mathf.Abs(i) == 1 && Mathf.Abs(j) == 1) ||(Mathf.Abs(i) == 1 && Mathf.Abs(j) == 0) || (Mathf.Abs(i) == 0 && Mathf.Abs(j) == 1)))
                {
                    raycastVector2[_timer] = new Vector2(i,j).normalized;
                    _timer++;
                }
            }
        }
    }

    private void DrawAll()
    {
        int _timer = 0;
        for(int i = -2; i <= 2; i++)
        {
            for(int j = 2; j >= -2; j--)
            {
                if(!((Mathf.Abs(i) + Mathf.Abs(j) == 0) ||(Mathf.Abs(i) == 1 && Mathf.Abs(j) == 1) ||(Mathf.Abs(i) == 1 && Mathf.Abs(j) == 0) || (Mathf.Abs(i) == 0 && Mathf.Abs(j) == 1)))
                {
                    DrawGizmosLines(new Vector2(i,j).normalized, _timer);
                    _timer++;
                }
            }
        }
    }

    private void Update()
    {
        if(fishMove.GetActivatedBool())
        {
            TheMostDanger();
        }

    }

    private void TheMostDanger()
    {
        danger = new float[rayCasted];
        index = new List<int>();
        List<RaycastHit2D> _allDangerObjects = new List<RaycastHit2D>();
        _allDangerObjects = FindAllDangerObjectsInProximity();

        if(_allDangerObjects.Count > 0)
        {
            List<Vector2> nearestDir = FindTheNearestDangerObjects(_allDangerObjects);
            CompareNearestDirUndRayCasts(nearestDir);
            DotProductDangerArray();
        }
    }

    private void DotProductDangerArray()
    {

        for(int j = 0; j < index.Count; j++)
        {
            Vector2 _saveVector = Vector2.zero;
            for(int i = 0; i < danger.Length; i++)
            {
                danger[i] += CompareVectorForDot(raycastVector2[index[j]], raycastVector2[i])*magnitude[j]; 
            }
        } 

        float _highestValue = -Mathf.Infinity;

        for(int i = 0; i < danger.Length; i++)
        {
            if(danger[i] < 0)
            {
                danger[i] = 0;
            }
            if(danger[i] > _highestValue)
            {
                _highestValue = danger[i];
            }
        }

        for(int i = 0; i < danger.Length; i++)
        {
            if(_highestValue != 0)
            danger[i] = danger[i]/_highestValue; 
        }
        
    }

    private void CompareNearestDirUndRayCasts(List<Vector2> _compareVec2)
    {
        for(int j = 0; j < _compareVec2.Count; j++)
        {
            int _save = 0;
            float _magnitude = 0;
            float _closestVector2 = -Mathf.Infinity;
            for(int i = 0; i < raycastVector2.Length; i++)
            {
                if(CompareVectorForDot(_compareVec2[j], raycastVector2[i])>_closestVector2)
                {
                    _closestVector2 = CompareVectorForDot(_compareVec2[j], raycastVector2[i]);
                    _save = i;
                    _magnitude = _compareVec2[j].magnitude;
                }
            }
            index.Add(_save);
            magnitude.Add(Mathf.Abs(_magnitude-1));
        }
    }

    private List<Vector2> FindTheNearestDangerObjects(List<RaycastHit2D> _allDangerObjects)
    {
        
        List<RaycastHit2D> howManyItems = FindSinglesInList(_allDangerObjects);
        int [] _index = new int[howManyItems.Count];

        List<Vector2> nearestDirections= new List<Vector2>();

        for(int j = 0; j < _index.Length; j++)
        {
            float _nearestDis = Mathf.Infinity;
            for(int i = 0; i < _allDangerObjects.Count;i++)
            {
                if(howManyItems[j].collider == _allDangerObjects[i].collider && _allDangerObjects[i].distance < _nearestDis)
                {
                    _nearestDis = _allDangerObjects[i].distance;
                    _index[j] = i;
                }
            }
        }

        for(int i = 0; i < _index.Length; i++)
        {
            nearestDirections.Add(GiveVector2BetweenTwoPoints((Vector2) this.transform.position, (Vector2) _allDangerObjects[_index[i]].point));
        }

        return nearestDirections;
    }

    private List<RaycastHit2D> FindSinglesInList(List<RaycastHit2D> _allDangerObjects)
    {
        List<RaycastHit2D> _objectNames = new List<RaycastHit2D>();
        _objectNames.Add(_allDangerObjects[0]);

        for(int i = 0; i < _allDangerObjects.Count;i++)
        {
            bool insideNameList = false;
            for(int j = 0; j < _objectNames.Count;j++)
            {
                if(_allDangerObjects[i].collider == _objectNames[j].collider)
                {
                    insideNameList = true;
                }
            }

            if(!insideNameList)
            {
                _objectNames.Add(_allDangerObjects[i]);
            }
        }

        return _objectNames;
    }

    private List<RaycastHit2D> FindAllDangerObjectsInProximity()
    {
        List<RaycastHit2D> _allDanger = new List<RaycastHit2D>();
        for(int i= 0; i < raycastVector2.Length;i++)
        {
            RaycastHit2D[] _arraySave = RaycastInDirection(raycastVector2[i]);
            if(_arraySave!=null)
            {
                for(int t= 0; t < _arraySave.Length;t++)
                {
                    if(_arraySave[t].collider != thisCollider)
                    {
                        _allDanger.Add(_arraySave[t]);
                    }
                }
            }
        }
        return _allDanger;
    }

    public float[] GetDangerWeight()
    {
        return danger;
    }

    public RaycastHit2D[] RaycastInDirection(Vector2 _dirOfRaycast)
    {
        RaycastHit2D [] hit = Physics2D.RaycastAll((Vector2) this.transform.position, _dirOfRaycast , RaycastRange, layerMask);
        if(hit.Length > 1)
        {
            return hit;
        }
        
        return null;
    }

    Vector2 GiveVector2BetweenTwoPoints(Vector2 pointA, Vector2 pointB)
	{
		Vector2 output = new Vector2(
			pointB.x-pointA.x,
			pointB.y-pointA.y
		);
		return output;
	}

    float GiveDistanceBetweenTwoPoints(Vector2 pointA, Vector2 pointB)
	{
		Vector2 output = new Vector2(
			pointB.x-pointA.x,
			pointB.y-pointA.y
		);
		return output.magnitude;
	}

    public float CompareVectorForDot(Vector2 _mainVec, Vector2 _secondVec)
    {
        return (Vector2.Dot(_mainVec.normalized, _secondVec.normalized));
    }

    void DrawGizmosLines(Vector2 _lineDir, int _input)
    {
        Gizmos.color = Color.white;

        bool inputInsideIndex = false;

        for(int i= 0; i < index.Count;i++)
        {
            if(_input == index[i])
            {
                inputInsideIndex = true;
            }
        }

        if(RaycastInDirection(_lineDir) != null)
        {
            Gizmos.color = Color.red;
        }

        if(!inputInsideIndex)
        {
            //Gizmos.DrawLine((Vector2) this.transform.position, (Vector2) this.transform.position + _lineDir);
            
            Gizmos.DrawLine((Vector2) this.transform.position, (Vector2) this.transform.position + _lineDir * danger[_input]);

        }else{
            Gizmos.color = Color.yellow;
            //Gizmos.DrawLine((Vector2) this.transform.position, (Vector2) this.transform.position + _lineDir);
            Gizmos.DrawLine((Vector2) this.transform.position, (Vector2) this.transform.position + _lineDir *danger[_input] );

            Gizmos.color = Color.red;
            //Gizmos.DrawLine((Vector2) this.transform.position, (Vector2) this.transform.position + _lineDir * 0.5f);
            Gizmos.DrawLine((Vector2) transform.position, (Vector2) transform.position + _lineDir *0.5f *danger[_input] );
        }
    }

    public void OnDrawGizmos() {
        // PopulateRaycastVector2Array();
        // TheMostDanger();
        // DrawAll();
    }
}
