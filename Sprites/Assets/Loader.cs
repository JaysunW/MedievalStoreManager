using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Loader : MonoBehaviour
{

    bool active = false;
    public void StartGame()
    {
        if(!active)
        {
            active = true;
            SceneChange.Instance.ChangeToLevel1();
        }
    }

    public void Load()
    {
        if(!active)
        {
            active = true;
            SceneChange.Instance.LoadGame();
        }
    }

    public void Exit()
    {
        if(!active)
        {
            active = true;
            SceneChange.Instance.ExitGame();
        }
    }
}
