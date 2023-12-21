using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Disable : MonoBehaviour
{
    public Button netButton;
    public Button laserButton;
    public Button knifeButton;
    public Button o2VolumeButton;

    public void changeButton(Button toBeDisableButton, bool _bool)
    {
        toBeDisableButton.interactable = _bool;
    }
    public void changeNetButton(bool _bool)
    {
        changeButton(netButton, _bool);
    }
    public void changeLaserButton(bool _bool)
    {
        changeButton(laserButton, _bool);
    }
    public void changeKnifeButton(bool _bool)
    {
        changeButton(knifeButton, _bool);
    }
    public void changeO2VolumeButton(bool _bool)
    {
        changeButton(o2VolumeButton, _bool);
    }
}
