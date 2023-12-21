using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FishEyes : MonoBehaviour
{
    public FishBehaviour fishBehaviour;
    public FishMove fishMove;
    public Collider2D thisCollider;

    private LayerMask blockMask = 1<<8;
    private LayerMask coralMask = 1<<10;
    private LayerMask fishMask = 1<<11;
    private LayerMask playerMask = 1<<13;

    public LayerMask layerMask;

    private int blockMaskInt = 8;
    private int coralMaskInt = 10;
    private int fishMaskInt = 11;
    private int playerMaskInt = 13;

    public int[] layerMasksInt = new int[4];

    private Vector2 moveVec;

    public int importancyCoral;
    public int importancyPlayer;
    public int importancyShell;
    public int importancyChest;


    private bool eyesOpen = false;
    public int eyeRange = 5;

    private Vector2 [] eyeSightVec2 = new Vector2[3];

    private bool changeTarget = false;

    public void LookToFollowingObject(Vector2 _input)
    {
        if(FindNearestObjectInDir(_input))
        {
            StopCoroutine("StartIdleAround");
        }else
        {
            StartCoroutine("StartIdleAround");
        }
        if(changeTarget && fishBehaviour.GetFishState() != FishStatesEnum.Wait)
        {
            StopCoroutine("StartIdleAround");
            fishBehaviour.SetFishState(FishStatesEnum.IdleAround);
            changeTarget = false;
        }
    }

    public void ChangeImportancy()
    {
        importancyPlayer = 5;
    }

    IEnumerator StartIdleAround()
    {
        yield return new WaitForSeconds(6);
        changeTarget = true;
        StopCoroutine("StartIdleAround");
    }

    private void PopulateRaycastVector2Array()
    {
        int timer = 0;
        for(int i = -1; i <= 1;i++)
        {
            moveVec = fishMove.GetMoveVec();
            eyeSightVec2[timer] = (moveVec + new Vector2(-moveVec.y,moveVec.x)*i*0.2f).normalized * eyeRange;
            timer++;
        }
    }

    private void DrawAll()
    {
        for(int i = -1; i <= 1;i++)
        {
            DrawGizmosLines((moveVec + new Vector2(-moveVec.y,moveVec.x)*i*0.2f).normalized * eyeRange);
        }
    }

    public void ChangeEye(bool _input)
    {
        eyesOpen = _input;
    }

    public void Update()
    {
        if(eyesOpen)
        {
            PopulateRaycastVector2Array();
            LookAround();
        }
    }   

    public void LookAround()
    {
        List<RaycastHit2D> objectsInView = new List<RaycastHit2D>();
        for(int i = 0; i < 3;i++)
        {
            if(FindNearestObjectInDir(eyeSightVec2[i]))
            {
                objectsInView.Add(RaycastInDirectionOnLayer(eyeSightVec2[i],layerMask));
            }
        }
        float _smallestDistance = Mathf.Infinity;
        int _index = 0;
        for(int i = 0; i < objectsInView.Count;i++)
        {
            if(objectsInView[i].distance < _smallestDistance)
            {
                _smallestDistance = objectsInView[i].distance;
                _index = i;
            }
        }
        if(objectsInView.Count > 0)
        {
            WhatObjectIsIt(objectsInView[_index]);
        }
    }

    private void WhatObjectIsIt(RaycastHit2D _input)
    {
        
        GameObject _target = _input.transform.gameObject;
        switch(_target.layer)
        {
            case 10:
                if(fishBehaviour.IsObjectSet(importancyCoral) && fishBehaviour.GetFishState() != FishStatesEnum.AttackPlayer)
                {
                    fishBehaviour.SetFishState(FishStatesEnum.IdleAroundObject);
                    fishBehaviour.SetObjectToFollow(_target, importancyCoral);
                }
            break;
            case 11:
                if(fishBehaviour.IsObjectSet(importancyPlayer) && fishBehaviour.GetFishState() != FishStatesEnum.AttackPlayer)
                {
                    fishBehaviour.SetFishState(FishStatesEnum.IdleAroundPLayer);
                    fishBehaviour.SetObjectToFollow(_target, importancyPlayer);
                }
            break;
            case 14:
                if(fishBehaviour.IsObjectSet(importancyShell) && fishBehaviour.GetFishState() != FishStatesEnum.AttackPlayer)
                {
                    fishBehaviour.SetFishState(FishStatesEnum.IdleAroundObject);
                    fishBehaviour.SetObjectToFollow(_target, importancyShell);
                }
            break;
            case 15:
                if(fishBehaviour.IsObjectSet(importancyChest) && fishBehaviour.GetFishState() != FishStatesEnum.AttackPlayer)
                {
                    fishBehaviour.SetFishState(FishStatesEnum.IdleAroundObject);
                    fishBehaviour.SetObjectToFollow(_target, importancyChest);
                }
            break;
        }
    }

    public RaycastHit2D RaycastInDirectionOnLayer(Vector2 _dirOfRaycast, LayerMask _inputLayer)
    {
        RaycastHit2D hit = Physics2D.Raycast((Vector2) this.transform.position, _dirOfRaycast, eyeRange,_inputLayer);
        return hit;
    }

    public RaycastHit2D[] RaycastInDirectionArray(Vector2 _dirOfRaycast)
    {
        RaycastHit2D [] hit = Physics2D.RaycastAll((Vector2) this.transform.position, _dirOfRaycast, eyeRange);
        if(hit.Length >= 1)
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

    private bool FindNearestObjectInDir(Vector2 _lineDir)
    {
        RaycastHit2D [] hit = Physics2D.RaycastAll((Vector2) this.transform.position, _lineDir, eyeRange,layerMask);
        float _smallestDistance = Mathf.Infinity;
        int _index = 0;
        for(int i =0; i < hit.Length; i++)
        {
            if(hit[i].distance < _smallestDistance)
            {
                _smallestDistance = hit[i].distance;
                _index = i;
            }
        }
        for(int i = 0; i < layerMasksInt.Length; i++)
        {
            if(hit.Length > 0 && hit[_index].transform.gameObject.layer == layerMasksInt[i])
            {
                return true;
            }
        }
        return false;
    }

    void DrawGizmosLines(Vector2 _lineDir)
    {
        Gizmos.color = Color.white;

        if(FindNearestObjectInDir(_lineDir))
        {
            Gizmos.color = Color.red;
        }

        Gizmos.DrawLine((Vector2) this.transform.position, (Vector2) this.transform.position + _lineDir.normalized * eyeRange);
    }

    public void OnDrawGizmos() {
        // if(eyesOpen)
        // {
        //    DrawAll();
        // }
    }
}
