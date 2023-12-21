using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InterestMap : MonoBehaviour
{
    public FishStats fishStats;
    public FishMove fishMove;
    public Collider2D thisCollider;

    private List<RaycastHit2D> dangerObjects = new List<RaycastHit2D>();
    private Vector2 interestDir = Vector2.zero;

    private int rayCasted = 16;
    private float [] interest = new float[16];
    public float RaycastRange = 1;

    private Vector2 [] raycastVector2 = new Vector2[16];

    private List<int> index = new List<int>();

    private void Start()
    {
        PopulateRaycastVector2Array();
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

    private void Update()
    {
        if(fishMove.GetActivatedBool())
        {
            TheInterest();
        }
    }

    public float[] GetInterestWeight()
    {
        return interest;
    }

    public Vector2 GetInterestDir()
    {
        return interestDir;
    }

    public void SetInterestDir(Vector2 _newDir)
    {
        interestDir = _newDir;
    }

    private void TheInterest()
    {
        interest = new float[rayCasted];
        CalculateInterest();
    }

    private void CalculateInterest()
    {
        for(int i = 0; i < raycastVector2.Length;i++)
        {
            interest[i] = CompareVectorForDot(interestDir, raycastVector2[i]);
        }

        for(int i = 0; i < interest.Length; i++)
        {
            if(interest[i] < 0)
            {
                interest[i] = 0;
            }
        }
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
        return ((1+Vector2.Dot(_mainVec.normalized, _secondVec.normalized))/2);
    }

    public RaycastHit2D[] RaycastInDirection(Vector2 _dirOfRaycast)
    {
        RaycastHit2D [] hit = Physics2D.RaycastAll((Vector2) this.transform.position, _dirOfRaycast , RaycastRange);
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

        if(!inputInsideIndex)
        {
            //Gizmos.DrawLine((Vector2) this.transform.position, (Vector2) this.transform.position + _lineDir);
            Gizmos.DrawLine((Vector2) this.transform.position, (Vector2) this.transform.position + _lineDir * interest[_input]);

        }else{
            Gizmos.color = Color.yellow;
            //Gizmos.DrawLine((Vector2) this.transform.position, (Vector2) this.transform.position + _lineDir);
            Gizmos.DrawLine((Vector2) this.transform.position, (Vector2) this.transform.position + _lineDir *interest[_input] );

            Gizmos.color = Color.red;
            //Gizmos.DrawLine((Vector2) this.transform.position, (Vector2) this.transform.position + _lineDir * 0.5f);
            Gizmos.DrawLine((Vector2) transform.position, (Vector2) transform.position + _lineDir *0.5f *interest[_input] );
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

    public void OnDrawGizmos() {
        // PopulateRaycastVector2Array();
        // TheInterest();
         //DrawAll();
    }
}
