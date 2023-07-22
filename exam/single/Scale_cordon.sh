cluster=$(kubectl config view |grep 'cluster: ' | cut -d ':' -f 2)

curl -s 'https://raw.githubusercontent.com/f0603026/CKAtest/main/exam/single/Deployment-Scale.sh' | bash
curl -s 'https://raw.githubusercontent.com/f0603026/CKAtest/main/exam/single/cordon_drain.sh'|bash
