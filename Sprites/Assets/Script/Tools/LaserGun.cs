using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LaserGun : MonoBehaviour
{
    private int laserMk;
    public int laserBreakdownPower;
    private int laserLength;
    public float laserCooldown;

    public GameObject[] laserParticle;
    public GameObject laserFirepointParticles;
    private Transform l_transform;

    private Vector2 laserEndPoint;
    public Transform laserFirePoint;
    public LineRenderer l_lineRenderer;

    public LayerMask blockLayer;

    private bool breakingDownBlock = false;

    public Sprite [] lasergunSkin;

    private string currentSceneName;
    private int test;

    void Start()
    {
        TurnOffAllParticles();
        currentSceneName = SceneManager.GetActiveScene().name;
        l_transform = GetComponent<Transform>();
        UpdateSkin();
    }

    private void TurnOffAllParticles()
    {
        for(int i = 0; i< laserParticle.Length;i++)
        {
            laserParticle[i].active = false;
        }
        laserFirepointParticles.active = false;
    }

    private void TurnOnAllParticles()
    {
        for(int i = 0; i< laserParticle.Length;i++)
        {
            laserParticle[i].active = true;
        }
    }

    private void SetPositionForParticles(Vector3 _inputVec3)
    {
        for(int i = 0; i< laserParticle.Length;i++)
        {
            laserParticle[i].transform.position = _inputVec3;
        }
    }

    public void UpdateSkin()
    {
        this.GetComponent<SpriteRenderer>().sprite = lasergunSkin[Tools.Instance.laserMK];
    }

    public void GetTheToolInfo(int _laserMk, int _laserBreakdownPower, int _laserLength, float _laserCooldown)
    {
        laserMk = _laserMk;
        laserBreakdownPower = _laserBreakdownPower;
        laserLength = _laserLength;
        laserCooldown = _laserCooldown;
    }

    // Update is called once per frame
    void Update()
    {
        if(currentSceneName != "Shop")
        {
            if(Input.GetButtonDown("Fire1"))    // when left mouse is pressed start the laser Renderer
            {
                EnableLaser();
            }

            if(Input.GetButton("Fire1"))    // when left mouse is still pressed activate breakdown of blocks     
            {
                UpdateLaser();
            }

            if(Input.GetButtonUp("Fire1"))  // when left mouse is released stop the laser Renderer
            {
                DisableLaser();
            }
        }
    }

    public void Reset()
    {
        TurnOffAllParticles();
        breakingDownBlock = false;
        l_lineRenderer.enabled = false;
    }

    void EnableLaser()
    {
        l_lineRenderer.enabled = true;
    }

    void UpdateLaser()
    {
        Vector2 mousePosition = Input.mousePosition;    // finds the mouse position
        mousePosition = Camera.main.ScreenToWorldPoint(mousePosition);

        Vector2 _laserDirectionNormalized = mousePosition - (Vector2) laserFirePoint.position;  
        
        Vector2 _laserLengthInGame = _laserDirectionNormalized;
        _laserDirectionNormalized.Normalize();

        RaycastHit2D hit = Physics2D.Raycast((Vector2)transform.position,_laserDirectionNormalized, Mathf.Min(_laserLengthInGame.magnitude,laserLength), blockLayer);
        laserParticle[1].active = true;
        laserFirepointParticles.active = true;

        laserFirepointParticles.transform.position = laserFirePoint.position;

        if(hit.collider != null) 
        {
            if(hit.collider.gameObject.tag == "Breakable")
            {
                BlockInfo hitBlockInfo = hit.collider.gameObject.GetComponent<BlockInfo>();

                if(laserMk >= hitBlockInfo.GetTier())
                {
                BreakDownFoundBlock(hit, hitBlockInfo);
                } else
                {
                    StartCoroutine(BlockToStrong(hitBlockInfo));
                    Debug.Log("Your laser is not strong enough");
                }
            }
            laserEndPoint = hit.point;
            laserParticle[0].active = true;
            SetPositionForParticles(laserEndPoint);
            
        }
        else if(_laserLengthInGame.magnitude > laserLength)
        {
            laserParticle[0].active = false;
            laserEndPoint = (Vector2) laserFirePoint.position + _laserDirectionNormalized * laserLength;
            SetPositionForParticles(laserEndPoint);
        }
        else
        {   
            laserParticle[0].active = false;
            laserEndPoint = mousePosition;
            SetPositionForParticles(laserEndPoint);
        }
        

        Draw2DRay(laserFirePoint.position, laserEndPoint);
    }

    private void BreakDownFoundBlock(RaycastHit2D _hit, BlockInfo _input)
    {
        if(!breakingDownBlock)
        {
            breakingDownBlock = true;
            StartCoroutine(BreakBlock(_input));
        }
    }

    IEnumerator BreakBlock(BlockInfo _hitBlockInfo)
    {   
        if(_hitBlockInfo != null)
            _hitBlockInfo.Breakdown(laserBreakdownPower + Random.Range(-2,2));
        yield return new WaitForSeconds(laserCooldown);
        breakingDownBlock = false; 
    }

    IEnumerator BlockToStrong(BlockInfo _hitBlockInfo)
    {   
        if(_hitBlockInfo != null)
            _hitBlockInfo.BlockToStrong();
        yield return new WaitForSeconds(laserCooldown);
        breakingDownBlock = false; 
    }

    void DisableLaser()
    {   
        l_lineRenderer.enabled = false;
        TurnOffAllParticles();
    }   

    void Draw2DRay(Vector2 startPos, Vector2 endPos)
    {
        l_lineRenderer.SetPosition(0, startPos);
        l_lineRenderer.SetPosition(1, endPos);
    }

    Vector2 findingVectorBetweenMouseAndObject(Transform _object)
    {
        Vector2 mousePosition = Input.mousePosition;
        mousePosition = Camera.main.ScreenToWorldPoint(mousePosition);
        Vector2 directionFromPlayerToMouse = new Vector2 (
            mousePosition.x - _object.position.x,
            mousePosition.y - _object.position.y
        );
        return directionFromPlayerToMouse;
    }
}
