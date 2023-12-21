using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GridManager : MonoBehaviour
{
    private bool gridGenerated;

    private void Update()
    {
        Scene currentScene = SceneManager.GetActiveScene();
        string sceneName = currentScene.name;

        if(!gridGenerated && sceneName.Equals("Level1"))
        {
            GridManagerStats.Instance.GenerateGrid();
            gridGenerated = true;
        }
    }
}