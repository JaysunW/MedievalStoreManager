using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class PauseM : MonoBehaviour
{
    public GameObject ui;

    private bool active = false;

    void Update ()
    {
        if(Input.GetKeyDown(KeyCode.Escape) || Input.GetKeyDown("p"))
        {
            Toggle();
        }
    }

    public void Toggle()
    {
        ui.SetActive(!ui.activeSelf);

        if(ui.activeSelf)
        {
            Time.timeScale = 0f;
        } else
        {
            Time.timeScale = 1f;
        }
    }

    public void Menu()
    {
        if(!active)
        {
            active = true;
            Time.timeScale = 1f;
            SceneChange.Instance.ChangeToMenu();
        }
    }

    public void ExitTheGame()
    {
        if(!active)
        {
            active = true;
            Time.timeScale = 1f;
            SceneChange.Instance.ExitGame();
        }
    }
}
