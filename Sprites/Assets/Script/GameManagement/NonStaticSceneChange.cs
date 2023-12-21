using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class NonStaticSceneChange : MonoBehaviour
{
    string input;
    public void ChangeScene(string _input)
    {
        input = _input;
        StartCoroutine(sceneFade());
    }

    public void ExitGame()
    {
        StartCoroutine("Exit");
    }

    IEnumerator Exit()
    {
        Blend.Instance.StartCoroutine("BlendTo");
        yield return new WaitForSeconds(Blend.Instance.HowLongWillItBlend()+1);
        Application.Quit();
    }

    IEnumerator sceneFade()
    {
        Blend.Instance.StartCoroutine("BlendTo");
        yield return new WaitForSeconds(Blend.Instance.HowLongWillItBlend()+1);
        SceneManager.LoadScene(input);
        Blend.Instance.StartCoroutine("BlendAway");
    }
}
