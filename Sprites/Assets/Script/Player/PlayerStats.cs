using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class PlayerStats : MonoBehaviour
{
    public static PlayerStats Instance { get; private set; }

    public GoldUI goldUI;
    private GameObject player;

    public Color goldPopupColor;

    [HideInInspector]
    public List<UsableToolsEnum> activeWeaponMode = new List<UsableToolsEnum>();

    [HideInInspector]
    public bool shiftCooldown;
    public int costumeMK = 0;

    [Header("Player specific Settings")]

    private int startHealth = 100;
    public int health;
    public int startO2 = 100;
    public int o2VolumeMK = 0;
    public int gold = 100;

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

    public void SetGameObjectPlayer(GameObject _player)
    {
        player = _player;
    }

    public void UpdateO2Volume(int _newVolume, int _mk)
    {
        SetStartO2(_newVolume);
        o2VolumeMK = _mk;
    }

    public void AddToCostumeMK(int _value)
    {
        costumeMK += _value;
        player.GetComponent<Player>().UpdateCostume();
    }

    public void SetCostumeMK(int _value)
    {
        costumeMK = _value;
        player.GetComponent<Player>().UpdateCostume();
    }

    public int GetCostumeMK()
    {
        return costumeMK;
    }

    public int Geto2Mk()
    {
        return o2VolumeMK;
    }

    public void SetStartO2(int _O2)
    {
        startO2 = _O2;
    }

    public int GetStartO2()
    {
        return startO2;
    }

    public void SetGoldUI(GoldUI _goldUI)
    {
        goldUI = _goldUI;
    }

    public void SetGold(int _gold)
    {
        gold = _gold;
        goldUI.ChangeGoldUI(gold);
    }

    public int GetGold()
    {
        return gold;
    }

    public void AddGold(float _amount)
    {
        gold += (int) _amount;
        if(_amount >0)
        {
            GameObject goldPopupGameObject = (GameObject) Instantiate(Resources.Load("Particles/GoldPopup"));
            GoldPopup goldPopup = goldPopupGameObject.GetComponent<GoldPopup>();
            goldPopup.SetPosition(player.transform.position);
            goldPopup.SetVelocity(RandomUpwardsUnitVector()*5);
            goldPopup.SetAmount((int) _amount);
            goldPopup.SetColor(goldPopupColor);

            GameObject particles = (GameObject) Instantiate(Resources.Load("Particles/Gold"));
            particles.transform.position = player.transform.position;
            Destroy(particles,1);
        }
        goldUI.ChangeGoldUI(gold);
    }

    public Vector2 RandomUpwardsUnitVector()
    {
        float random = Random.Range(0.3f* Mathf.PI, 0.7f * Mathf.PI);
        return new Vector2(Mathf.Cos(random), Mathf.Sin(random));
    }

    public void TakeGold(int _amount)
    {
        if(!(gold + _amount < 0))
        {
            gold -= _amount;
            goldUI.ChangeGoldUI(gold);
        }else
        {
            gold = 0;
            goldUI.ChangeGoldUI(gold);
        }
        
    }
}
