using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneChange : MonoBehaviour
{
    public static SceneChange Instance { get; private set; }

    public void ChangeScene(string _input)
    {
        SceneManager.LoadScene(_input);
    }

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

    public void ChangeToMenu()
    {
        StartCoroutine("LoadMenu");
    }

    public void ChangeToLevel1()
    {
        StartCoroutine("StartGame");
    }

    public void ExitGame()
    {
        StartCoroutine("Exit");
    }

    public void LoadGame()
    {
        StartCoroutine("LoadAllData");
    }

    IEnumerator Exit()
    {
        Blend.Instance.StartCoroutine("BlendTo");
        yield return new WaitForSeconds(Blend.Instance.HowLongWillItBlend()+0.2f);
        Application.Quit();
    }

    IEnumerator LoadMenu()
    {
        Blend.Instance.StartCoroutine("BlendTo");
        yield return new WaitForSeconds(Blend.Instance.HowLongWillItBlend()+0.2f);
        ChangeScene("Shop");
        yield return new WaitForSeconds(0.1f);
        ResetAll();
        yield return new WaitForSeconds(0.1f);
        ChangeScene("Menu");
        Blend.Instance.StartCoroutine("BlendAway");
    }

    IEnumerator StartGame()
    {
        Blend.Instance.StartCoroutine("BlendTo");
        yield return new WaitForSeconds(Blend.Instance.HowLongWillItBlend()+0.2f);
        ChangeScene("Level1");
        Blend.Instance.StartCoroutine("BlendAway");
    }

    IEnumerator LoadAllData()
    {
        Blend.Instance.StartCoroutine("BlendTo");
        yield return new WaitForSeconds(Blend.Instance.HowLongWillItBlend()+0.2f);
        ChangeScene("Level1");
        yield return new WaitForSeconds(0.1f);
        ChangeScene("Shop");
        yield return new WaitForSeconds(0.1f);
        LoadData();
        yield return new WaitForSeconds(0.1f);
        ChangeScene("Level1");
        Blend.Instance.StartCoroutine("BlendAway");
    }

    public void SaveData()
    {
        SaveMerge.Instance.SetVariables();
        SaveSystem.SaveData(SaveMerge.Instance);
    }

    public void LoadData()
    {
        GameData data = SaveSystem.LoadData();
        SaveMerge.Instance.loadVariablesBack(data);
    }

    public void ResetAll()
    {
        GameData data = SaveSystem.Reset();
        SaveMerge.Instance.loadVariablesBack(data);
    }
}
