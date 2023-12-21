using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ActivateOtherCam : MonoBehaviour
{
    public GameObject otherCam;


    public void Activate()
    {
        otherCam.SetActive(true);
        this.gameObject.SetActive(false);
    }
}
