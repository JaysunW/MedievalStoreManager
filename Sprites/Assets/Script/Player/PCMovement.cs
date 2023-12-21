using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class PCMovement : MonoBehaviour
{
    public float spawnHeight = 5;

    [Header("PlayerMove Settings")]
    public Rigidbody2D playerRigidbody;
    private float playerMovX,playerMovY;
    public int playerSpeed = 100;     // the speed the player has

    [Header("WaterShift Settings")]
    public int waterShiftSpeed = 400;
    public float shiftTime = 0.3f;
    public float shiftCooldownTime = 1f;
    private bool waterShift = false;   // is watersprint active
    private bool waterSprintCooldown = false;   // is the waterprint cooldowned

    public int gravityScaleAboveWater = 30;
    public float gravityScaleUnderWater = 1.5f;

    private float tileSize;
    private int cols;
    private int rows;

    private bool noO2 = false;
    

    // Start is called before the first frame update
    void Start()
    {
        tileSize = GridManagerStats.Instance.tileSize;
        cols = GridManagerStats.Instance.cols;
        rows = GridManagerStats.Instance.rows;

        this.transform.position = new Vector2(tileSize * (cols-1)/2,spawnHeight);
    }

    // Update is called once per frame
    void Update()
    {
        Scene currentScene = SceneManager.GetActiveScene();
        string sceneName = currentScene.name;

        if(!sceneName.Equals("Shop") && !noO2)
        {
            playerMovX = Input.GetAxis("Horizontal");
            playerMovY = Input.GetAxis("Vertical");
            PlayerStats.Instance.shiftCooldown = waterSprintCooldown;
        
            if (Input.GetMouseButtonDown(1) && !waterShift && !waterSprintCooldown){
            
                StartCoroutine(WaterShift(Time.realtimeSinceStartup,findingVectorBetweenMouseAndPlayer() ));
            }   
        }else
        {
            this.gameObject.GetComponent<Rigidbody2D>().gravityScale = 0;
            playerMovX = 0;
            playerMovY = 0;
        }
    }

    public void PlayerHasNoO2()
    {
        noO2 = true;
        this.gameObject.GetComponent<Rigidbody2D>().isKinematic = true;
        playerRigidbody.velocity = Vector2.zero;
    }

    Vector2 findingVectorBetweenMouseAndPlayer()
    {
        Vector2 mousePosition = Input.mousePosition;
        mousePosition = Camera.main.ScreenToWorldPoint(mousePosition);
        Vector2 directionFromPlayerToMouse = new Vector2 (
            mousePosition.x - transform.position.x,
            mousePosition.y - transform.position.y
        );
        return directionFromPlayerToMouse;
    }
    
    IEnumerator WaterShift(float tmpTime, Vector2 _directionFromPlayerToMouse)
    {
        waterShift = true;
        while ( Time.realtimeSinceStartup <= tmpTime+shiftTime)
        {
            if(!noO2)
            playerRigidbody.velocity = _directionFromPlayerToMouse.normalized * waterShiftSpeed * Time.deltaTime;
            yield return new WaitForSeconds(.01f);
        }
        waterShift = false;
        waterSprintCooldown = true;
        StartCoroutine(WaterShiftCooldown(Time.realtimeSinceStartup));
    }

    IEnumerator WaterShiftCooldown(float tmpTime)
    {
        while ( Time.realtimeSinceStartup <= tmpTime+shiftCooldownTime)
        {
            yield return new WaitForSeconds(.1f);
        }
        waterSprintCooldown = false;
    }

    void FixedUpdate()
    {
        if(!waterShift){    // the movement of the player is activated if he isn't watershifting
            Vector2 tmpVector = playerRigidbody.velocity;
            tmpVector.x = playerMovX * playerSpeed;
            tmpVector.y = playerMovY * playerSpeed;
            playerRigidbody.velocity = (tmpVector) * Time.deltaTime;
        }
    }
}

