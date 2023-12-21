using UnityEngine;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;

public static class SaveSystem
{
    public static void SaveData(SaveMerge saveMerge)
    {
        BinaryFormatter formatter = new BinaryFormatter();
        string path = Application.persistentDataPath + "/player.LetsGoBitch";
        FileStream stream = new FileStream(path, FileMode.Create);

        GameData data = new GameData(saveMerge);

        formatter.Serialize(stream, data);
        stream.Close();
    }

    public static GameData Reset()
    {
        string path = Application.persistentDataPath + "/player.Reset";
        if(File.Exists(path))
        {
            BinaryFormatter formatter = new BinaryFormatter();
            FileStream stream = new FileStream(path, FileMode.Open);

            GameData data = formatter.Deserialize(stream) as GameData;
            stream.Close();

            return data;
        }else
        {
            Debug.Log("Save file not found in " + path);
            return null;
        }
    }

    public static GameData LoadData()
    {
        string path = Application.persistentDataPath + "/player.LetsGoBitch";
        if(File.Exists(path))
        {
            BinaryFormatter formatter = new BinaryFormatter();
            FileStream stream = new FileStream(path, FileMode.Open);

            GameData data = formatter.Deserialize(stream) as GameData;
            stream.Close();

            return data;
        }else
        {
            Debug.Log("Save file not found in " + path);
            return null;
        }
    }
}
