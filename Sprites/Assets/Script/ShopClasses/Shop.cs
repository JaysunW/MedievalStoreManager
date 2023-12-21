using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Shop : MonoBehaviour
{
    public KnifeMK [] knifeMK;
    public LaserMK [] laserMK;
    public KaescherMK [] kaescherMK;
    public O2VolumeMK [] o2VolumeMK;

    private int o2MK;

    public Kaescher kaescher;
    public Knife knife;
    public LaserGun laserGun;

    public Text kaescherCost;
    public Text laserCost;
    public Text knifeCost;
    public Text O2VolumeCost;

    public Disable disable;

    private float buttonDisableTimeNotEnoughGold = 1;

    void Start()
    {
        SaveMerge.Instance.SetShop(this.gameObject.GetComponent<Shop>());
        if(Tools.Instance.kaescherMK == kaescherMK.Length)
        {
            disable.changeNetButton(false);
            UpdateCostBox(kaescherCost,"");
        }else{
            UpdateCostBox(kaescherCost,kaescherMK[Tools.Instance.kaescherMK].cost.ToString());
        }
        if(Tools.Instance.laserMK == laserMK.Length)
        {
            disable.changeLaserButton(false);
            UpdateCostBox(laserCost,"");
        }else{
            UpdateCostBox(laserCost,laserMK[Tools.Instance.laserMK].cost.ToString());
        }
        if(Tools.Instance.knifeMK == knifeMK.Length)
        {
            disable.changeKnifeButton(false);
            UpdateCostBox(knifeCost,"");
        }else{
            UpdateCostBox(knifeCost,knifeMK[Tools.Instance.knifeMK].cost.ToString());
        }
        if(PlayerStats.Instance.o2VolumeMK == o2VolumeMK.Length)
        {
            disable.changeO2VolumeButton(false);
            UpdateCostBox(O2VolumeCost,"");
        }else{
            UpdateCostBox(O2VolumeCost,o2VolumeMK[PlayerStats.Instance.o2VolumeMK].cost.ToString());
        }

    }

    public void BuyFishingNet()
    {
        if(Tools.Instance.kaescherMK < kaescherMK.Length)
        {
            KaescherMK newKaescher = kaescherMK[Tools.Instance.kaescherMK];
            if(newKaescher.cost <= PlayerStats.Instance.gold)
            {
                PlayerStats.Instance.TakeGold(newKaescher.cost);
                if(Tools.Instance.kaescherMK == kaescherMK.Length-1)
                { 
                    Tools.Instance.UpdateKaescher(newKaescher.mk, newKaescher.cooldown, newKaescher.range);
                    UpdateCostBox(kaescherCost, "");
                    kaescher.UpdateSkin();
                    disable.changeNetButton(false);
                }else{
                    Tools.Instance.UpdateKaescher(newKaescher.mk, newKaescher.cooldown, newKaescher.range);
                    newKaescher = kaescherMK[Tools.Instance.kaescherMK];
                    kaescher.UpdateSkin();
                    UpdateCostBox(kaescherCost, newKaescher.cost.ToString());
                }
            }else{
                StartCoroutine(NotEnoughGold(UsableToolsEnum.Kaescher));
                Debug.Log("ZU wenig Gold.");
            }
        }
    }

    public void SetFishingNet(int _input)
    {
        int _mk = _input -1;
        if(_mk == -1)
        {
            KaescherMK newKaescher = Tools.Instance.GetFirstNetMK();
            Tools.Instance.UpdateKaescher(newKaescher.mk, newKaescher.cooldown, newKaescher.range);
            newKaescher = kaescherMK[Tools.Instance.kaescherMK];
            kaescher.UpdateSkin();
            UpdateCostBox(kaescherCost, newKaescher.cost.ToString());
            disable.changeNetButton(true);
        }else
        {
            KaescherMK newKaescher = kaescherMK[_mk];
            if(_mk == kaescherMK.Length-1)
            { 
                Tools.Instance.UpdateKaescher(newKaescher.mk, newKaescher.cooldown, newKaescher.range);
                UpdateCostBox(kaescherCost, "");
                kaescher.UpdateSkin();
                disable.changeNetButton(false);
            }else{
                Tools.Instance.UpdateKaescher(newKaescher.mk, newKaescher.cooldown, newKaescher.range);
                newKaescher = kaescherMK[Tools.Instance.kaescherMK];
                kaescher.UpdateSkin();
                UpdateCostBox(kaescherCost, newKaescher.cost.ToString());
                disable.changeNetButton(true);
            }
        } 
    }

    public void BuyLaserGun()
    {
        if(Tools.Instance.laserMK < laserMK.Length)
        {
            LaserMK newLaser = laserMK[Tools.Instance.laserMK];
            if(newLaser.cost <= PlayerStats.Instance.gold)
            {
                PlayerStats.Instance.TakeGold(newLaser.cost);
                if(Tools.Instance.laserMK == laserMK.Length-1)
                {
                    Tools.Instance.UpdateLasergun(newLaser.mk,newLaser.breakdownPower,newLaser.cooldown,newLaser.length);
                    UpdateCostBox(laserCost, "");
                    laserGun.UpdateSkin();
                    disable.changeLaserButton(false);
                }else{
                    Tools.Instance.UpdateLasergun(newLaser.mk,newLaser.breakdownPower,newLaser.cooldown,newLaser.length);
                    newLaser = laserMK[Tools.Instance.laserMK];
                    laserGun.UpdateSkin();
                    UpdateCostBox(laserCost, newLaser.cost.ToString());
                }
            }else{
                StartCoroutine(NotEnoughGold(UsableToolsEnum.Laser));
                Debug.Log("ZU wenig Gold.");
            }
        }
    }

    public void SetLaser(int _input)
    {
        int _mk = _input -1;
        if(_mk == -1)
        {
            LaserMK newLaser = Tools.Instance.GetFirstLaserMK();
            Tools.Instance.UpdateLasergun(newLaser.mk,newLaser.breakdownPower,newLaser.cooldown,newLaser.length);
            newLaser = laserMK[Tools.Instance.laserMK];
            laserGun.UpdateSkin();
            UpdateCostBox(laserCost, newLaser.cost.ToString());
            disable.changeLaserButton(true);
        }else
        {
            LaserMK newLaser = laserMK[_mk];
            if(_mk == laserMK.Length-1)
            {
                Tools.Instance.UpdateLasergun(newLaser.mk,newLaser.breakdownPower,newLaser.cooldown,newLaser.length);
                UpdateCostBox(laserCost, "");
                laserGun.UpdateSkin();
                disable.changeLaserButton(false);
            }else{
                Tools.Instance.UpdateLasergun(newLaser.mk,newLaser.breakdownPower,newLaser.cooldown,newLaser.length);
                newLaser = laserMK[Tools.Instance.laserMK];
                laserGun.UpdateSkin();
                UpdateCostBox(laserCost, newLaser.cost.ToString());
                disable.changeLaserButton(true);
            }
        } 
    }

    public void BuyKnife()
    {
        if(Tools.Instance.knifeMK < knifeMK.Length)
        {
            KnifeMK newKnife = knifeMK[Tools.Instance.knifeMK];
            if(newKnife.cost <= PlayerStats.Instance.gold)
            {
                PlayerStats.Instance.TakeGold(newKnife.cost);
                if(Tools.Instance.knifeMK == knifeMK.Length-1)
                {
                    Tools.Instance.UpdateKnife(newKnife.mk,newKnife.damage,newKnife.range);
                    UpdateCostBox(knifeCost, "");
                    knife.UpdateSkin();
                    disable.changeKnifeButton(false);
                }else{
                    Tools.Instance.UpdateKnife(newKnife.mk,newKnife.damage,newKnife.range);
                    newKnife = knifeMK[Tools.Instance.knifeMK];
                    knife.UpdateSkin();
                    UpdateCostBox(knifeCost, newKnife.cost.ToString());
                }
            }else{
                StartCoroutine(NotEnoughGold(UsableToolsEnum.Knife));
                Debug.Log("ZU wenig Gold.");
            }
        }
    }

    public void SetKnife(int _input)
    {
        int _mk = _input -1;
        if(_mk == -1)
        {
            KnifeMK newKnife = Tools.Instance.GetFirstKnifeMK();
            Tools.Instance.UpdateKnife(newKnife.mk,newKnife.damage,newKnife.range);
            newKnife = knifeMK[Tools.Instance.knifeMK];
            knife.UpdateSkin();
            UpdateCostBox(knifeCost, newKnife.cost.ToString());
            disable.changeKnifeButton(true);
        }else
        {
            KnifeMK newKnife = knifeMK[_mk];
            if(_mk == knifeMK.Length-1)
            {
                Tools.Instance.UpdateKnife(newKnife.mk,newKnife.damage,newKnife.range);
                UpdateCostBox(knifeCost, "");
                knife.UpdateSkin();
                disable.changeKnifeButton(false);
            }else{
                Tools.Instance.UpdateKnife(newKnife.mk,newKnife.damage,newKnife.range);
                newKnife = knifeMK[Tools.Instance.knifeMK];
                knife.UpdateSkin();
                UpdateCostBox(knifeCost, newKnife.cost.ToString());
                disable.changeKnifeButton(true);
            }
        } 
    }

    public void BuyO2Volume()
    {
        if( PlayerStats.Instance.o2VolumeMK < o2VolumeMK.Length)
        {
            O2VolumeMK newO2VolumeMK = o2VolumeMK[PlayerStats.Instance.o2VolumeMK];
            if(newO2VolumeMK.cost <= PlayerStats.Instance.gold)
            {
                PlayerStats.Instance.TakeGold(newO2VolumeMK.cost);
                if(PlayerStats.Instance.o2VolumeMK == o2VolumeMK.Length-1)
                {
                    PlayerStats.Instance.UpdateO2Volume(newO2VolumeMK.volume,newO2VolumeMK.mk);
                    PlayerStats.Instance.AddToCostumeMK(2);
                    UpdateCostBox(O2VolumeCost, "");
                    disable.changeO2VolumeButton(false);

                }else{
                    PlayerStats.Instance.UpdateO2Volume(newO2VolumeMK.volume,newO2VolumeMK.mk);
                    PlayerStats.Instance.AddToCostumeMK(2);
                    newO2VolumeMK = o2VolumeMK[PlayerStats.Instance.o2VolumeMK];
                    UpdateCostBox(O2VolumeCost, newO2VolumeMK.cost.ToString());
                }
            }else{
                StartCoroutine(NotEnoughGold(UsableToolsEnum.O2Volume));
                Debug.Log("ZU wenig Gold.");
            }
        }
    }

    public void SetO2(int _input)
    {
        int _mk = _input -1;
        if(_mk == -1)
        {
            O2VolumeMK newO2VolumeMK = Tools.Instance.GetFirsto2MK();
            PlayerStats.Instance.UpdateO2Volume(newO2VolumeMK.volume,newO2VolumeMK.mk);
            PlayerStats.Instance.SetCostumeMK(0);
            newO2VolumeMK = o2VolumeMK[PlayerStats.Instance.o2VolumeMK];
            UpdateCostBox(O2VolumeCost, newO2VolumeMK.cost.ToString());
            disable.changeO2VolumeButton(true);
        }else
        {
            O2VolumeMK newO2VolumeMK = o2VolumeMK[_mk];
            if(_mk == o2VolumeMK.Length-1)
            {
                PlayerStats.Instance.UpdateO2Volume(newO2VolumeMK.volume,newO2VolumeMK.mk);
                PlayerStats.Instance.SetCostumeMK((_mk+1)*2);
                UpdateCostBox(O2VolumeCost, "");
                disable.changeO2VolumeButton(false);
            }else{
                PlayerStats.Instance.UpdateO2Volume(newO2VolumeMK.volume,newO2VolumeMK.mk);
                PlayerStats.Instance.SetCostumeMK((_mk+1)*2);
                newO2VolumeMK = o2VolumeMK[PlayerStats.Instance.o2VolumeMK];
                UpdateCostBox(O2VolumeCost, newO2VolumeMK.cost.ToString());
                disable.changeO2VolumeButton(true);
            }
        } 
    }


    IEnumerator NotEnoughGold(UsableToolsEnum _tool)
    {
        float timer = 0;
        switch (_tool)
        {
            case UsableToolsEnum.Kaescher:
                disable.changeNetButton(false);
            break;
            case UsableToolsEnum.Laser:
                disable.changeLaserButton(false);
            break;
            case UsableToolsEnum.Knife:
                disable.changeKnifeButton(false);
            break;
            case UsableToolsEnum.O2Volume:
                disable.changeO2VolumeButton(false);
            break;
        }

        yield return new WaitForSeconds(buttonDisableTimeNotEnoughGold);

        switch (_tool)
        {
            case UsableToolsEnum.Kaescher:
                disable.changeNetButton(true);
            break;
            case UsableToolsEnum.Laser:
                disable.changeLaserButton(true);
            break;
            case UsableToolsEnum.Knife:
                disable.changeKnifeButton(true);
            break;
            case UsableToolsEnum.O2Volume:
                disable.changeO2VolumeButton(true);
            break;
        }
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

    private void UpdateCostBox(Text cost, string newCost)
    {
        cost.text = newCost;
    }
}
