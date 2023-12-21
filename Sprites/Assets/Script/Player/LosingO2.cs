using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LosingO2 : MonoBehaviour
{
    public O2VolumeUI o2VolumeUI;
    public Color damageColor;
    
    public int startO2Drainige = 2;
    private int o2DrainigePerSec;

    private bool o2Empty;

    public int o2;

    Scene currentScene;
    string sceneName;

    void Start()
    {
        currentScene = SceneManager.GetActiveScene();
        sceneName = currentScene.name;
        o2DrainigePerSec = startO2Drainige;
        o2 = PlayerStats.Instance.GetStartO2();
        o2VolumeUI.SetStartO2(o2);
        if(!sceneName.Equals("Shop"))
            StartCoroutine(IELosingO2());
    }

    public void DamageO2Tank(int _damage)
    {
        GameObject goldPopupGameObject = (GameObject) Instantiate(Resources.Load("Particles/GoldPopup"));
        GoldPopup goldPopup = goldPopupGameObject.GetComponent<GoldPopup>();
        goldPopup.SetPosition(this.transform.position);
        goldPopup.SetVelocity(RandomUpwardsUnitVector()*5);
        goldPopup.SetAmount((int) _damage);
        goldPopup.SetColor(damageColor);

        GameObject particles = (GameObject) Instantiate(Resources.Load("Particles/Blood"));
        particles.transform.position = this.transform.position;
        Destroy(particles,1);
        o2 -= _damage;
        o2VolumeUI.O2change(o2);
    }

    public Vector2 RandomUpwardsUnitVector()
    {
        float random = Random.Range(0.3f* Mathf.PI, 0.7f * Mathf.PI);
        return new Vector2(Mathf.Cos(random), Mathf.Sin(random));
    }

    IEnumerator IELosingO2()
    {
        while (!o2Empty)
        {
            if(!sceneName.Equals("Shop"))
            {
                o2 -= o2DrainigePerSec;
                o2VolumeUI.O2change(o2);
            
                if(o2 <= 0)
                {
                    o2Empty = true;
                    O2Empty();
                }
            }
            yield return new WaitForSeconds(1);
        }
    }

    private void O2Empty()
    {
        BackToTheShip.Instance.O2Empty();
    }

}
