# Goal of the hackathon

The goal is to familiarize with the KillerDroid framework. 
KillerDroid is a toolchain that enables to generate Android Adversarial Examples (AAEs) attacks to evaluate the robustness of state of the art malware scanners.

## An overview of KillerDroid

To generate AAEs from existing malware, KillerDroid needs three inputs:

- a benign application,
- a malware application, and
- an obfuscation tactic expressed as a set of **obfuscations operations** to hide the malware behavior into the benign application. 

KillerDroid leverages both `Soot` and `APKtool` to extracts files from the APKs given as inputs. Concretely, Soot is used to extract **bytecode** whereas APKtool is used to extract all other files such as **resources**. 

Depending on the obfuscation operations, KillerDroid compiler applies a sequence of four phases: instrumentation, dissimulation, resource merging, and APK building. 

## Getting started with KillerDroid

KillerDroid is wrapped in a **Docker container** and a specific command line is provided to easily generate malwares and evaluate their **detectability**.

### Prerequisites 

- Docker version 20.10.16, build aa7e414

1. Clone the repository (**2.8MB**) [https://github.com/djobiii2078/hackathon-docker-killerdroid.git](https://github.com/djobiii2078/hackathon-docker-killerdroid.git)
`git clone https://github.com/djobiii2078/hackathon-docker-killerdroid.git`
2. Connect to your docker account : `docker login -u hackathon-token -p jF4JQuyykynqUt92zsr- registry.gitlab.inria.fr` 
3. Build the latest image from your Dockerfile: 
`docker build -t hackathon:latest .` (**5.79GB**)
4. Most functionalities of the packer and analysis tool require AndroidSDK to be installed. Ideally, you need several versions depending on the *apks* and *functionalities* you ought to use. A helper script that install the sdks up to *android-6* is provided.
`chmod +x installSDKs.sh`
`./installSDKs.sh`
5. Now that you have everything install, you can launch a notebook environment that bootstraps all the necessary tools with: 
`docker run -ti -p 8888:8888 hackathon:latest` or append the directory for your `SDKs` in case you will rely on some functionalities : 
`docker run -ti -v <PATH_TO_HOST_ANDROID_SDK>:/Android/sdk-p 8888:8888 hackathon:latest`
6. You can view some command-line examples in the jupyter nootebook `examples.ipynb`



### Generate a malware 
To generate a new malware, you need to define a configuration file that tells the packer the strategy to use and provide a couple (benign and malicious application).

Here is an example of a configuration file: 

```json
{
  "manifest": "replace",
  "resources": "merge",
  "maliciousBytecode": {
    "transformation": "encrypt",
    "dissimulation": "withinBytecode"
  },
  "codeLoading": {
    "java": {
      "bootstrapSequence": {
        "methodCount": 1,
        "methodCallImplementation": "reflection"
      },
      "bootloaderHandling": {
        "useBootloader": {
          "transformation": "plain",
          "dissimulation": "existingFile",
          "sequenceImplementation": "plainJava"
        }
      }
    }
  }
}


```
 
Either, you directly use the **.jar**, 
```java
!java -jar /app/killerdroidpacker.jar -c app/kdp_conf.json -p /app/rand_conf.json -b examples/com.clarins.productlibrary.apk -m /app/koler-a-fe666e209e094968d3178ecf0cf817164c26d5501ed3cd9a80da786a4a3f3dc4.apk
```

Or use the packer tool as in the notebook example :).


### Source code

Feel free to peak inside the `code source` of **killerdroid** (`git clone https://hackathon-docker:jF4JQuyykynqUt92zsr-@gitlab.inria.fr/andromak/killerdroid_packer`) and **python-andromak** (`git clone https://hackathon-dockern:FswaN_5RSXJx5bWaqN_L@gitlab.inria.fr/andromak/killerdroid_packer`), to understand the different classes and determine how you can either extend or build your own solution.


## Your task :) 

### Red Team 

Your goal is to try to propose a new malware generation mechanism/idea. The goal is to either leverage existing killerDroid libraries or either build your own from scratch. 

Your mechanism should be motivated using a pseudo-algorithm that explain the key idea and why it should work. 

### Blue Team 

Your goal is to improve malware detection by proposing a new AI model. Concretely, you can propose a new feature and a way of extracting it from the APK to build new models. 
Due to training time, that can be excessively high, consider training your model with a few number of inputs from the dataset provided when testing your solution. 

### Deliverables 

Each team is supposed to present their work and if possible perform either a live demo or show details proving their implementation. 

However, knowing the time constraint and task complexity, we will emphasize on the idea and the work that led to the implementation of a prototype. 
We are not waiting a fully functional solution but one that give a gist of the underneath idea.

**Presentation time: 30minutes**

## Results


🥇 Gold Medal
```
Batchayon Fotie William, University of Douala, Cameroon
Kouayep Tankio Jocelyn, University of Douala, Cameroon
Moguem Souop Audrey Cyrielle, University of Douala, Cameroon
Sangala Mballa Louis Michel, University of Douala, Cameroon
Waha Lindjeck Wilson Emmanuel, University of Douala, Cameroon
```

🥈 Silver Medal 
```
Ekwelle Ndocky Beril Brandone, University of Yaoundé 1, Cameroon
Eyenga Ovono Tatiana, University of Yaoundé 1, Cameroon
Gounou Jordan, University of Yaoundé 1, Cameroon
Mbietieu Amos Mbietieu, University of Yaoundé 1, Cameroon
```




