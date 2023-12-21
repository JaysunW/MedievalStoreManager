using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class WhatToolIsUsed : MonoBehaviour
{
    public SelectedTool selectedTool;

    private UsableToolsEnum activeTool;

    public List<GameObject> tools = new List<GameObject>();

    public static float realtimeSinceStartup;

    public int toolChanger = 0;
    private int toolChangerSave = 0;
    private bool toolChangerChanges = false;
    public bool knifeUnlocked;

    Scene currentScene;
    string sceneName;

    private int mouseWheelChange;

    void Start()
    {
        currentScene = SceneManager.GetActiveScene();
        sceneName = currentScene.name;

        Tools.Instance.SetKaescherScripts(tools[0].GetComponent<Kaescher>());
        Tools.Instance.SetLaserGunScripts(tools[1].GetComponent<LaserGun>());
        Tools.Instance.SetKnifeScripts(tools[2].GetComponent<Knife>());
        Tools.Instance.SetTheToolsInfos();

        PopulateActivePlayerTools();
    
        ChangeToolByEnum(PlayerStats.Instance.activeWeaponMode[toolChanger]);

        if(!sceneName.Equals("Shop"))
            selectedTool.UpdateTheToolAndResetOtherIMG(toolChanger);

        if(!knifeUnlocked)
            selectedTool.WhatStillLocked();
    }

    void Update()
    {
        if(!sceneName.Equals("Shop"))
            selectedTool = GameObject.FindGameObjectWithTag("ToolButtons").GetComponent<SelectedTool>();
    }

    public void ChangeTool(int _tool)
    {
        Debug.Log("Help");
        toolChanger = _tool;
        WhatToolIsActiveWhatIsDeactivated();
    }

    private void OnGUI()
    {
        if(Input.GetAxis("Mouse ScrollWheel") > 0)
        {
            mouseWheelChange++;
        }
        if(Input.GetAxis("Mouse ScrollWheel") < 0)
        {
            mouseWheelChange--;
        }

        if(mouseWheelChange > 4 || mouseWheelChange < -4)
        {
            toolChangerChanges = true;
        }
        if(toolChangerChanges)
        {
            if(mouseWheelChange > 0)
            {
                toolChanger++;
            }else if(mouseWheelChange <= 0)
            {
                toolChanger--;
            }
            if(toolChanger >= PlayerStats.Instance.activeWeaponMode.Count)
            {
                toolChanger = 0;
            }else if(toolChanger < 0)
            {
                toolChanger = PlayerStats.Instance.activeWeaponMode.Count-1;
            }
                Debug.Log("Hello");
            if(toolChanger >= 0 && toolChanger < PlayerStats.Instance.activeWeaponMode.Count)
            {
                ChangeToolByEnum(PlayerStats.Instance.activeWeaponMode[toolChanger]);
            }
            if(!sceneName.Equals("Shop"))
                selectedTool.UpdateTheToolAndResetOtherIMG(toolChanger);
            mouseWheelChange = 0;
            toolChangerChanges = false;
        }
    }

    private void PopulateActivePlayerTools()
    {
        PlayerStats.Instance.activeWeaponMode = new List<UsableToolsEnum>();
        PlayerStats.Instance.activeWeaponMode.Add(UsableToolsEnum.Kaescher);
        PlayerStats.Instance.activeWeaponMode.Add(UsableToolsEnum.Laser);
        if(knifeUnlocked)
            PlayerStats.Instance.activeWeaponMode.Add(UsableToolsEnum.Knife);
    }

    public void ChangeToolByEnum(UsableToolsEnum _activeTool)
    {
        Debug.Log("WTF");
        activeTool = _activeTool;
        WhatToolIsActiveWhatIsDeactivated();
    }

    private void WhatToolIsActiveWhatIsDeactivated()
    {
        tools[toolChanger].SetActive(true);
        DeactivateAllSecondaryTools();
    }

    private void DeactivateAllTools()
    {
        tools[0].SetActive(false);
        tools[1].SetActive(false);
        tools[2].SetActive(false);
    }

    private void DeactivateAllSecondaryTools()
    {
        for(int i = 0; i < tools.Count; i ++)
        {
            if(i != toolChanger)
                tools[i].SetActive(false);
            switch(i)
            {
                case 0:
                    tools[0].GetComponent<Kaescher>().Reset();
                break;
                case 1:
                    tools[1].GetComponent<LaserGun>().Reset();
                break;
                case 2:
                    tools[2].GetComponent<Knife>().Reset();
                break;
            }
        }
    }
}