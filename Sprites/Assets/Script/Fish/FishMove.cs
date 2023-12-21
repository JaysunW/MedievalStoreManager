using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FishMove : MonoBehaviour
{
    public Rigidbody2D rigidbody2D;
    public FishStats fishStats;

    public InterestMap interestMap;
    public DangerMap dangerMap;

    private Vector2 moveVec = Vector2.zero;
    
    private int speed;

    public int startLerpStrength = 250;
    private int lerpStrength;

    private float [] interestWeight;
    private Vector2 interestVec;
    private float [] dangerWeight;
    private Vector2 dangerVec;

    Vector2 smoothVec;

    public bool activated = false;
    public int idleRange = 3;          

    private int [] index = new int [2];

    private Vector2 [] raycastVector2 = new Vector2[16];

    private void UpdateInterestMap()
    {
        interestWeight = interestMap.GetInterestWeight();
    }

    private void UpdateDangerMap()
    {
        dangerWeight = dangerMap.GetDangerWeight();
    }

    private void Start()
    {
        lerpStrength = startLerpStrength;
        speed = fishStats.GetSpeed();
        PopulateRaycastVector2Array();
    }

    public void SetLerpStrength(int _lerpStrength)
    {
        lerpStrength = _lerpStrength;
    }

    public int GetStartLerpStrength()
    {
        return startLerpStrength;
    }

    public bool GetActivatedBool()
    {
        return activated;
    }

    public void ResetMoveVec()
    {
        activated = false;
    }

    public void SetInterestVec(Vector2 _inputVec)
    {   
        interestMap.SetInterestDir(_inputVec);
    }

    private void Update()
    {
        if(activated)
        {
            UpdateDangerMap();
            UpdateInterestMap();

            interestVec = CalculateInterestVec();
            dangerVec = CalculateDangerVec();


            smoothVec = interestVec.normalized - dangerVec.normalized;

            float lerpRange = CompareVectorForDot(dangerVec, moveVec);

            moveVec = Vector2.Lerp(moveVec, smoothVec,lerpRange);
    
            rigidbody2D.velocity = moveVec.normalized * speed * Time.deltaTime * CompareVectorForSpeed(dangerVec, moveVec);
        }
    }

    public void SetSpeed(int _speed)
    {
        speed = _speed;
    }

    public Vector2 GetMoveVec()
    {
        if(!activated)
        {
            if(moveVec == Vector2.zero)
            {
                moveVec = RandomUnitVector();
            }
            activated = true;
        }
        return moveVec;
    }

    public Vector2 RandomUnitVector()
    {
        float random = Random.Range(0f, 2f * Mathf.PI);
        return new Vector2(Mathf.Cos(random), Mathf.Sin(random));
    }

    public float CompareVectorForDot(Vector2 _mainVec, Vector2 _secondVec)
    {
        return (1.1f + Vector2.Dot(_mainVec.normalized, _secondVec.normalized))/lerpStrength;
    }

    public float CompareVectorForSpeed(Vector2 _mainVec, Vector2 _secondVec)
    {
        return (-3 + Vector2.Dot(_mainVec.normalized, _secondVec.normalized))/-2;
    }

    private Vector2 CalculateDangerVec()
    {
        Vector2 _output = Vector2.zero;

        for(int i = 0; i < dangerWeight.Length; i++)
        {
            if(RaycastInDirection(raycastVector2[i]) != null)
            {
                _output += raycastVector2[i] * dangerWeight[i];
            }
        }
        
        return _output;
    }

    private Vector2 CalculateInterestVec()
    {
        Vector2 _output = Vector2.zero;

        for(int i = 0; i < interestWeight.Length; i++)
        {
            if(RaycastInDirection(raycastVector2[i]) == null)
            {
                _output += raycastVector2[i] * interestWeight[i];
            }
        }
        return _output.normalized;
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

    public RaycastHit2D[] RaycastInDirection(Vector2 _dirOfRaycast)
    {
        RaycastHit2D [] hit = Physics2D.RaycastAll((Vector2) this.transform.position, _dirOfRaycast , 1);
        if(hit.Length > 1)
        {
            return hit;
        }
        return null;
    }

    void DrawGizmosLines(Vector2 _lineDir, int _input)
    {
        Gizmos.color = Color.white;

        bool inputInsideIndex = false;

        if(RaycastInDirection(_lineDir) != null)
        {
            Gizmos.color = Color.red;
        }

        Gizmos.DrawLine((Vector2) this.transform.position, (Vector2) this.transform.position + _lineDir *0);
    }


    public void OnDrawGizmos() {
        if(activated)
        {
            Gizmos.color = Color.blue;
            Gizmos.DrawLine((Vector2) transform.position, (Vector2) transform.position + smoothVec.normalized);
            Gizmos.color = Color.white;
            Gizmos.DrawLine((Vector2) transform.position, (Vector2) transform.position + interestVec.normalized);
            Gizmos.color = Color.red;
            Gizmos.DrawLine((Vector2) transform.position, (Vector2) transform.position + dangerVec.normalized);
            Gizmos.color = Color.yellow;
            Gizmos.DrawLine((Vector2) transform.position, (Vector2) transform.position + moveVec.normalized);
        }
    }
}
