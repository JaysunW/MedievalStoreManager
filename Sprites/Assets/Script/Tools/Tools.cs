using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Tools : MonoBehaviour
{
    public static Tools Instance { get; private set; }

    [Header("Laser Gun Settings")]

    public LaserGun laserGun;
    public int laserMK = 0;
    public int laserBreakdownPower = 10;
    public float laserCooldownSec = 1f;
    public int laserLength = 1;

    [Header("Knife Settings")]

    public Knife knife;
    public int knifeMK = 0;
    public int knifeDamage = 20; 
    public float knifeRange = 0.5f;

    [Header("Kaescher Settings")]

    public Kaescher kaescher;
    public int kaescherMK = 0;
    public float kaescherCooldownSec = 1f;
    public float kaescherRange = 0.5f;

    public KnifeMK firstKnifeMK;
    public LaserMK firstLaserMK;
    public KaescherMK firstKaescherMK;
    public O2VolumeMK firstO2VolumeMK;

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

    public KnifeMK GetFirstKnifeMK()
    {
        return firstKnifeMK;
    }

    public LaserMK GetFirstLaserMK()
    {
        return firstLaserMK;
    }

    public KaescherMK GetFirstNetMK()
    {
        return firstKaescherMK;
    }

    public O2VolumeMK GetFirsto2MK()
    {
        return firstO2VolumeMK;
    }

    public void UpdateKnife(int _mk, int _damage, float _range)
    {
        knifeMK = _mk;
        knifeDamage = _damage;
        knifeRange = _range;
    }

    public void UpdateKaescher(int _mk, float _cooldown, float _range)
    {
        kaescherMK = _mk;
        kaescherCooldownSec = _cooldown;
        kaescherRange = _range;
    }

    public void UpdateLasergun(int _mk, int _damage, float _cooldown, int _length)
    {
        laserMK = _mk;
        laserBreakdownPower = _damage;
        laserCooldownSec = _cooldown;
        laserLength = _length;
    }

    public void SetLaserGunScripts(LaserGun _laserGun)
    {
        laserGun = _laserGun;
    }

    public void SetKnifeScripts(Knife _knife)
    {
        knife = _knife;
    }

    public void SetKaescherScripts(Kaescher _kaescher)
    {
        kaescher = _kaescher;
    }

    public int GetNetMk()
    {
        return kaescherMK;
    }

    public int GetLaserMk()
    {
        return laserMK;  
    }

    public int GetKnifeMk()
    {
        return knifeMK;
    }

    public void SetTheToolsInfos()
    {
        laserGun.GetTheToolInfo(laserMK, laserBreakdownPower, laserLength, laserCooldownSec);
        knife.GetTheToolInfo(knifeMK, knifeDamage, knifeRange);
        kaescher.GetTheToolInfo(kaescherMK, kaescherCooldownSec, kaescherRange);
    }
}
