using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class ActivateShadow : MonoBehaviour
{
    public GameObject player;
    public GameObject [] shadow;
    private string currentScene;

    private float levelHeight;

    private float [] shadowBorder;

    void Start()
    {
        currentScene = SceneManager.GetActiveScene().name;
        if(currentScene.Equals("Level1"))
        {
            shadowBorder = new float[shadow.Length-1];
            SetTheOppacityTo0(shadow);
            SetGameObjectsActiveMode(shadow,false);
            CalculateLength();
            StretchShadowOverLevelHeight();
        }
    }

    private void CalculateLength()
    {
        float tileSize = GridManagerStats.Instance.tileSize;
        float rows = GridManagerStats.Instance.rows;
        levelHeight = rows * tileSize;
    }

    private void SetTheOppacityTo0(GameObject [] _input)
    {
        for(int i = 0; i < _input.Length;i++)
        {
            if(_input[i].GetComponent<Image>() != null)
                _input[i].GetComponent<Image>().color = new Vector4(1,1,1,0);
        }
    }

    private void SetGameObjectsActiveMode(GameObject [] _inputGameObject, bool _inputBool)
    {
        for(int i = 0; i < _inputGameObject.Length;i++)
        {
            _inputGameObject[i].active = _inputBool;
        }
    }

    private void StretchShadowOverLevelHeight()
    {
        for(int i = 0; i< shadowBorder.Length; i++)
        {
            shadowBorder[i] = (levelHeight/shadow.Length)*(i+1);
        }
    }

    private void ChangeAlphaOfShadow(float _playerDepth, Image _shadow)
    {
        float alphaChange = _playerDepth/shadowBorder[0];
        _shadow.color = new Vector4(1,1,1,alphaChange);
    }

    void Update()
    {
        float _playerDepth = Mathf.Abs(player.transform.position.y);
        if(_playerDepth < shadowBorder[0])
        {
            shadow[0].active = true;
            shadow[1].active = false;
            shadow[2].active = false;
            ChangeAlphaOfShadow(_playerDepth, shadow[0].GetComponent<Image>());
        }else if(_playerDepth >= shadowBorder[0] && _playerDepth < shadowBorder[1])
        {

            shadow[1].active = true;
            shadow[2].active = false;
            ChangeAlphaOfShadow(_playerDepth - shadowBorder[0], shadow[1].GetComponent<Image>());
        }else if(_playerDepth >= shadowBorder[1])
        {
            shadow[2].active = true;
            ChangeAlphaOfShadow(_playerDepth-shadowBorder[1], shadow[2].GetComponent<Image>());
        }
    }
}
