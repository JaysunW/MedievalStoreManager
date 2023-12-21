using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Test : MonoBehaviour
{
    Vector2 testInterestVec;

    private int rayCasted = 16;
    private float [] interest = new float[16];

    public float test1;
    public float test2;

    private Vector2 [] raycastVector2 = new Vector2[16];
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void CalculateInterest()
    {
        for(int i = 0; i < raycastVector2.Length;i++)
        {
            interest[i] = CompareVectorForDot(testInterestVec, raycastVector2[i]);
        }

        float _highestValue = -Mathf.Infinity;

        for(int i = 0; i < interest.Length; i++)
        {
            if(interest[i] > _highestValue)
                _highestValue = interest[i];
        }
    }

    public float CompareVectorForDot(Vector2 _mainVec, Vector2 _secondVec)
    {
        return -Mathf.Abs(Vector2.Dot(_mainVec.normalized, _secondVec.normalized))+1;
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
                    DrawGizmosLines(raycastVector2[_timer],_timer);
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

        Gizmos.DrawLine((Vector2) this.transform.position, (Vector2) this.transform.position + _lineDir *interest[_input]);
    }

    public void OnDrawGizmos() {   
        testInterestVec = (Vector2) (Camera.main.ScreenToWorldPoint(Input.mousePosition) - this.transform.position);
        PopulateRaycastVector2Array();
        CalculateInterest();
    }
}
