using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FishBehaviour : MonoBehaviour
{
    [Header ("Scripts")]
    private GameObject objectToFollow;
    public GameObject fishSpriteGameObject;
    public Rigidbody2D rigidbody2D;
    public FishStats fishStats;
    public FishMove fishMove;
    public InterestMap interestMap;
    public DangerMap dangerMap;
    public FishEyes fishEyes;
    public FishStatesEnum fishState;

    private Vector2 testVector;

    private int importancyValue = 0;

    [Header ("Ranges")]
    private float idleRange;
    public float idleObjectRange = 1.5f;
    public float idlePlayerRange = 2.5f;   

    [Header ("Attack Timing")]
    public float attackMinTimer = 2;
    public float attackMaxTimer = 3;

    private LayerMask playerMask = 1<<11;

    private Vector2 delayedTargetPosition;
    public bool aggressive = false;
    private bool attacking = false;
    public bool active = false;
    private bool lookedOnTarget = false;

    public Transform mouth;
    public int fishDamage = 10;
    public float attackRange = 2;
    public float attackSpeedMultiply = 5;
    public int attackLerp = 10;

    public void ActivateFish()
    {
        active = true;
    }

    public void DeactivateFish()
    {
        active = false;
        Reset();
    }

    private void Update()
    {   
        if(active)
        {
            switch(fishState)
            {
                case FishStatesEnum.IdleAround:
                    IdleAround();
                break;
                case FishStatesEnum.IdleAroundObject:
                    IdleAroundObject();
                break;
                case FishStatesEnum.IdleAroundPLayer:
                    IdleAroundPlayer();
                    return;
                break;
                case FishStatesEnum.AttackPlayer:
                    AttackPlayer();
                    return;
                break;
            }
            fishEyes.ChangeEye(true);
            

            if(aggressive)
            {
                fishEyes.ChangeImportancy();
                dangerMap.ChangeMode("normal");
                fishMove.SetSpeed(fishStats.GetSpeed());
                fishMove.SetLerpStrength(fishMove.GetStartLerpStrength());
                attacking = false;
                lookedOnTarget = false;
                StopCoroutine("AttackAfterTime");
                StopCoroutine("Attack");
            }
        }
    }

    public void SetAggression(bool _input)
    {
        aggressive = _input;
    }

    public bool GetAggression()
    {
        return aggressive;
    }

    public void SetDamage(int _damage)
    {
        fishDamage = _damage;
    }

    private void Reset()
    {
        delayedTargetPosition = Vector3.zero;
        fishEyes.ChangeEye(false);
        fishMove.ResetMoveVec();
        objectToFollow = null;
        idleRange = 0;
        testVector = Vector2.zero;
        importancyValue = 0;
        rigidbody2D.velocity = Vector2.zero;
    }

    public bool IsObjectSet(int _input)
    {
        if(_input > importancyValue)
            return true;
        return false;
    }

    public void SetObjectToFollow(GameObject _newObject, int _input)
    {
        objectToFollow = _newObject;
        importancyValue = _input;
    }

    public FishStatesEnum GetFishState()
    {
        return fishState;
    }

    public void SetFishState(FishStatesEnum _fishState)
    {
        fishState = _fishState;
    }

    private void IdleAround()
    {
        testVector = Vector2.zero;
        importancyValue = 0;
        interestMap.SetInterestDir(fishMove.GetMoveVec());
    }

    private void IdleAroundPlayer()
    {
        idleRange = idlePlayerRange;
        FollowObject();
    }

    private void IdleAroundObject()
    {
        idleRange = idleObjectRange;
        FollowObject();
    }

    private void AttackPlayer()
    {
        if(objectToFollow != null)
        {
            if(!lookedOnTarget)
            {
                fishMove.SetSpeed((int)(fishStats.GetSpeed() * attackSpeedMultiply));
                fishMove.SetLerpStrength(attackLerp);
                dangerMap.ChangeMode("attack");
                lookedOnTarget = true;
                delayedTargetPosition = (Vector2) objectToFollow.transform.position;
                testVector =  delayedTargetPosition - (Vector2) this.transform.position;
                delayedTargetPosition += testVector.normalized * 1f;
                StartCoroutine("Attack");
            }

            Vector2 Vector2ToPlayer = (Vector2) objectToFollow.transform.position - (Vector2) this.transform.position;
            testVector =  delayedTargetPosition - (Vector2) this.transform.position;
            
            fishEyes.LookToFollowingObject(Vector2ToPlayer);
            interestMap.SetInterestDir(testVector);
        }
        else
        {
            SetFishState(FishStatesEnum.IdleAround);
        }
    }

    private IEnumerator Attack()
    {
        float timer = 0;

        GameObject particles = (GameObject) Instantiate(Resources.Load("Particles/AttackParticles"),fishSpriteGameObject.transform);

        fishSpriteGameObject.transform.rotation = Quaternion.Euler(0,0,-22.5f);
        particles.transform.position = this.transform.position;
        Destroy(particles,1);

        Collider2D hitplayer = Physics2D.OverlapCircle(mouth.position, attackRange, playerMask);
        while(timer < 40 && hitplayer == null && (GiveVector2BetweenTwoPoints((Vector2) this.transform.position, delayedTargetPosition).magnitude > 0.7f))
        {
            timer += Time.deltaTime;
            delayedTargetPosition -= testVector * timer/320;
            hitplayer = Physics2D.OverlapCircle(mouth.position, attackRange, playerMask);
            if(hitplayer != null && hitplayer.GetComponent<LosingO2>() != null)
            {
                hitplayer.GetComponent<LosingO2>().DamageO2Tank(fishDamage);
                dangerMap.ChangeMode("normal");
                fishMove.SetLerpStrength(fishMove.GetStartLerpStrength());
            }
            yield return new WaitForSeconds(0);
        }

        delayedTargetPosition = Vector3.zero;
        fishMove.SetSpeed(fishStats.GetSpeed());
        fishMove.SetLerpStrength(fishMove.GetStartLerpStrength());
        dangerMap.ChangeMode("normal");
        lookedOnTarget = false;
        attacking = false;
        SetFishState(FishStatesEnum.IdleAroundPLayer);
        StopCoroutine("Attack");
    }

    private IEnumerator AttackAfterTime()
    {
        yield return new WaitForSeconds(Random.Range(attackMinTimer,attackMaxTimer));
        SetFishState(FishStatesEnum.AttackPlayer);
    }

    private void FollowObject()
    {
        if(objectToFollow != null)
        {
            testVector = (Vector2)(objectToFollow.transform.position - this.transform.position);
            fishEyes.LookToFollowingObject(testVector);
            if(testVector.magnitude < idleRange && testVector.magnitude > idleRange - 0.5f)
            {
                if(WhichIsBetter(testVector))
                {
                    interestMap.SetInterestDir(new Vector2(testVector.y,-testVector.x)*0.8f);
                }else
                {
                    interestMap.SetInterestDir(new Vector2(-testVector.y,testVector.x)*0.8f);
                }
            }else if(testVector.magnitude < idleRange - 0.5f)
            {
                if(WhichIsBetter(testVector))
                {
                    interestMap.SetInterestDir(new Vector2(testVector.y,-testVector.x)*0.8f -testVector);
                }else
                {
                    interestMap.SetInterestDir(new Vector2(-testVector.y,testVector.x)*0.8f -testVector);
                }
            }else
            {
                interestMap.SetInterestDir(testVector);
            }

            if(aggressive  && !attacking && objectToFollow.tag == "Player")
            {
                attacking = true;
                StartCoroutine("AttackAfterTime");
            }
        }
        else
        {
            SetFishState(FishStatesEnum.IdleAround);
        }
    }

    private bool WhichIsBetter(Vector2 _inputVec)
    {
        if(CompareForDot(new Vector2(_inputVec.y,-_inputVec.x), fishMove.GetMoveVec()) > CompareForDot(new Vector2(-_inputVec.y,_inputVec.x), fishMove.GetMoveVec()))
        {
            return true;
        }else
        {
            return false;
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

    public float CompareForDot(Vector2 _mainVec, Vector2 _secondVec)
    {
        return Vector2.Dot(_mainVec.normalized, _secondVec.normalized);
    }

    public RaycastHit2D RaycastInDirectionOnLayer(Vector2 _dirOfRaycast, LayerMask _inputLayer)
    {
        RaycastHit2D hit = Physics2D.Raycast((Vector2) this.transform.position, _dirOfRaycast, 5,_inputLayer);
        return hit;
    }

    void DrawGizmosLines(Vector2 _lineDir)
    {
        Gizmos.color = Color.white;
        if(objectToFollow != null)
        {
            if(RaycastInDirectionOnLayer(_lineDir,objectToFollow.layer) != null)
            {
                Gizmos.color = Color.red;
            }
        }

        Gizmos.DrawLine((Vector2) this.transform.position, (Vector2) this.transform.position + _lineDir.normalized * 5);
    }

    public void OnDrawGizmos() {
        DrawGizmosLines(testVector);
        Gizmos.DrawWireSphere(mouth.position,attackRange);
        Gizmos.DrawWireSphere(delayedTargetPosition,0.65f);
    }
}
