using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class BackToTheShip : MonoBehaviour
{
    public static BackToTheShip Instance { get; private set; }

    private GameObject player;
    private Transform playerTF;
    private GameObject ship;
    private Transform shipTF;
    private GameObject hook;
    private Transform hookTF;
    private GameObject rope;
    private Transform ropeTF;
    private Rope ropeScript;

    private void Awake()
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

    public void SetGameObjectPlayer(GameObject _player)
    {
        player = _player;
        playerTF = player.GetComponent<Transform>();
    }

    public void SetShip(GameObject _ship)
    {
        ship = _ship;
        shipTF = _ship.GetComponent<Transform>();
    }

    public void SetHook(GameObject _hook)
    {
        hook = _hook;
        hookTF = hook.GetComponent<Transform>();
    }

    public void SetRope(GameObject _rope)
    {
        rope = _rope;
        ropeTF = rope.GetComponent<Transform>();
        ropeScript = rope.GetComponent<Rope>();
    }

    public void O2Empty()
    {
        hook.SetActive(true);
        rope.SetActive(true);
        player.GetComponent<PCMovement>().PlayerHasNoO2();
        GameObject.FindGameObjectWithTag("MainCamera").GetComponent<ActivateOtherCam>().Activate();
        StartCoroutine("ToTheShip");
    }

    IEnumerator ToTheShip()
    {
        ActivateBlocks.Instance.ChangeActive(false);
        int gridWidth = GridManagerStats.Instance.cols;
        int gridWidthHalf = (int) gridWidth/2;
        Vector2 shipPosition = (Vector2) shipTF.position;
        Vector2 hookDirection;
        bool isHookOnPlayer = false;
        while(!isHookOnPlayer)
        {
            hookDirection = (Vector2) playerTF.position - shipPosition;
            hookTF.Translate(hookDirection.normalized*0.08f);
            ropeScript.Draw2DRay(shipPosition, (Vector2)hookTF.position-hookDirection.normalized*0.5f);
            if(((Vector2) hookTF.position - (Vector2) playerTF.position).magnitude < 0.5f)
            {
                isHookOnPlayer=true;
            }
            yield return new WaitForSeconds(0.01f);
        }
        hookDirection = shipPosition - (Vector2) playerTF.position;
        int timer = 0;
        bool isPlayerOnBoat = false;
        while(!isPlayerOnBoat)
        {
            playerTF.Translate(hookDirection.normalized*0.1f);
            hookTF.Translate(hookDirection.normalized*0.1f);
            ropeScript.Draw2DRay(shipPosition, (Vector2)hookTF.position + hookDirection.normalized*0.5f);
            if((shipPosition - (Vector2) playerTF.position).magnitude < 0.5)
            {
                isPlayerOnBoat = true;
            }else if(timer >= 80)
            {
                isPlayerOnBoat = true;
            }
            timer++;
            yield return new WaitForSeconds(0.01f);
        }
        ActivateBlocks.Instance.ChangeActive(true);
        SceneManager.LoadScene("Shop");
    }
}
