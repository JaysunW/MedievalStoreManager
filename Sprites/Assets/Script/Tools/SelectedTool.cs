using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SelectedTool : MonoBehaviour
{
    public GameObject BKeascher;
    public GameObject BLaser;
    public GameObject BKnife;

    private float notUsedToolVis = 0.314f;
    private int usedToolVis =  1;

    public void WhatStillLocked()
    {
        Image _buttonImage = BKnife.GetComponent<Image>();
        _buttonImage.color = new Color(0.5f, 0.5f, 0.5f, notUsedToolVis);
        GameObject toolImage = BKnife.transform.GetChild(0).gameObject;
        Image _image = toolImage.GetComponent<Image>();
        _image.color = new Color(0, 0, 0, notUsedToolVis);
    }

    public void UpdateTheToolAndResetOtherIMG(int _tool)
    {
        switch(_tool)
        {
            case 0:
            UpdateIMG(BKeascher);    
            break;
            case 1:
            UpdateIMG(BLaser);
            break;
            case 2:
            UpdateIMG(BKnife);
            break;
        }
        ResetWhichOtherIMG(_tool);
    }

    private void ResetWhichOtherIMG(int _tool)
    {
        switch(_tool)
        {
            case 0:
            ResetIMG(BKnife);
            ResetIMG(BLaser);    
            break;
            case 1:
            ResetIMG(BKeascher);
            ResetIMG(BKnife);
            break;
            case 2:
            ResetIMG(BLaser);
            ResetIMG(BKeascher);
            break;
        }
    }

    private void UpdateIMG(GameObject _gameObject)
    {
        Image _buttonImage = _gameObject.GetComponent<Image>();
        _buttonImage.color = new Color(_buttonImage.color.r, _buttonImage.color.g, _buttonImage.color.b, usedToolVis);
        GameObject toolImage = _gameObject.transform.GetChild(0).gameObject;
        Image _image = toolImage.GetComponent<Image>();
        _image.color = new Color(_image.color.r, _image.color.g, _image.color.b, usedToolVis);
    }

    private void ResetIMG(GameObject _gameObject)
    {
        Image _buttonImage = _gameObject.GetComponent<Image>();
        _buttonImage.color = new Color(_buttonImage.color.r, _buttonImage.color.g, _buttonImage.color.b, notUsedToolVis);
        GameObject toolImage = _gameObject.transform.GetChild(0).gameObject;
        Image _image = toolImage.GetComponent<Image>();
        _image.color = new Color(_image.color.r, _image.color.g, _image.color.b, notUsedToolVis);
    }
}
