# Задача 0

<img width="442" height="43" alt="image" src="https://github.com/user-attachments/assets/335ec8f0-1fc7-4d49-bb88-ce20f4070b76" />

**Проверка версии Docker Compose**

# Задача 1

<img width="723" height="363" alt="image" src="https://github.com/user-attachments/assets/bdacdaf1-d8a3-4f33-9337-e0bb1239d96e" />

**Сборка образа и запуск контейнера**

<img width="724" height="150" alt="image" src="https://github.com/user-attachments/assets/a249bfaf-3006-41cb-a7e1-653a960236f4" />

**Запуск приложения через venv**

<img width="735" height="195" alt="image" src="https://github.com/user-attachments/assets/8ff39fa0-c32c-4e3b-8ece-de4c6dc2fbcd" />

**Управление названием таблицы через ENV переменную**

# Задача 2

mustway@mustway-server:~/projects/my-fork/shvirtd-example-python$ yc container image scan --id crp8suf1guqh4mtnnra4
done (1m1s)
id: chet2h05e93s953qbo4j
image_id: crp8suf1guqh4mtnnra4
scanned_at: "2026-04-26T15:11:47.068Z"
status: READY
vulnerabilities:
  high: "6"
  medium: "29"
  low: "72"
  undefined: "1"

[
  {
    "package": {
      "name": "CVE-2025-69720",
      "link": "https://avd.aquasec.com/nvd/cve-2025-69720",
      "package": "libncursesw6",
      "source": "trivy",
      "version": "6.5+20250216-2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "HIGH"
  },
  {
    "package": {
      "name": "CVE-2026-29111",
      "link": "https://avd.aquasec.com/nvd/cve-2026-29111",
      "package": "libsystemd0",
      "source": "trivy",
      "version": "257.9-1~deb13u1",
      "origin": "os",
      "type": "debian"
    },
    "severity": "HIGH"
  },
  {
    "package": {
      "name": "CVE-2025-69720",
      "link": "https://avd.aquasec.com/nvd/cve-2025-69720",
      "package": "libtinfo6",
      "source": "trivy",
      "version": "6.5+20250216-2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "HIGH"
  },
  {
    "package": {
      "name": "CVE-2026-29111",
      "link": "https://avd.aquasec.com/nvd/cve-2026-29111",
      "package": "libudev1",
      "source": "trivy",
      "version": "257.9-1~deb13u1",
      "origin": "os",
      "type": "debian"
    },
    "severity": "HIGH"
  },
  {
    "package": {
      "name": "CVE-2025-69720",
      "link": "https://avd.aquasec.com/nvd/cve-2025-69720",
      "package": "ncurses-base",
      "source": "trivy",
      "version": "6.5+20250216-2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "HIGH"
  },
  {
    "package": {
      "name": "CVE-2025-69720",
      "link": "https://avd.aquasec.com/nvd/cve-2025-69720",
      "package": "ncurses-bin",
      "source": "trivy",
      "version": "6.5+20250216-2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "HIGH"
  },
  {
    "package": {
      "name": "CVE-2026-27456",
      "link": "https://avd.aquasec.com/nvd/cve-2026-27456",
      "package": "bsdutils",
      "source": "trivy",
      "version": "1:2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "MEDIUM"
  },
  {
    "package": {
      "name": "CVE-2026-27456",
      "link": "https://avd.aquasec.com/nvd/cve-2026-27456",
      "package": "libblkid1",
      "source": "trivy",
      "version": "2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "MEDIUM"
  },
  {
    "package": {
      "name": "CVE-2026-4046",
      "link": "https://avd.aquasec.com/nvd/cve-2026-4046",
      "package": "libc-bin",
      "source": "trivy",
      "version": "2.41-12+deb13u2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "MEDIUM"
  },
  {
    "package": {
      "name": "CVE-2026-4437",
      "link": "https://avd.aquasec.com/nvd/cve-2026-4437",
      "package": "libc-bin",
      "source": "trivy",
      "version": "2.41-12+deb13u2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "MEDIUM"
  },
  {
    "package": {
      "name": "CVE-2026-4438",
      "link": "https://avd.aquasec.com/nvd/cve-2026-4438",
      "package": "libc-bin",
      "source": "trivy",
      "version": "2.41-12+deb13u2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "MEDIUM"
  },
  {
    "package": {
      "name": "CVE-2026-5450",
      "link": "https://avd.aquasec.com/nvd/cve-2026-5450",
      "package": "libc-bin",
      "source": "trivy",
      "version": "2.41-12+deb13u2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "MEDIUM"
  },
  {
    "package": {
      "name": "CVE-2026-5928",
      "link": "https://avd.aquasec.com/nvd/cve-2026-5928",
      "package": "libc-bin",
      "source": "trivy",
      "version": "2.41-12+deb13u2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "MEDIUM"
  },
  {
    "package": {
      "name": "CVE-2026-4046",
      "link": "https://avd.aquasec.com/nvd/cve-2026-4046",
      "package": "libc6",
      "source": "trivy",
      "version": "2.41-12+deb13u2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "MEDIUM"
  },
  {
    "package": {
      "name": "CVE-2026-4437",
      "link": "https://avd.aquasec.com/nvd/cve-2026-4437",
      "package": "libc6",
      "source": "trivy",
      "version": "2.41-12+deb13u2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "MEDIUM"
  },
  {
    "package": {
      "name": "CVE-2026-4438",
      "link": "https://avd.aquasec.com/nvd/cve-2026-4438",
      "package": "libc6",
      "source": "trivy",
      "version": "2.41-12+deb13u2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "MEDIUM"
  },
  {
    "package": {
      "name": "CVE-2026-5450",
      "link": "https://avd.aquasec.com/nvd/cve-2026-5450",
      "package": "libc6",
      "source": "trivy",
      "version": "2.41-12+deb13u2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "MEDIUM"
  },
  {
    "package": {
      "name": "CVE-2026-5928",
      "link": "https://avd.aquasec.com/nvd/cve-2026-5928",
      "package": "libc6",
      "source": "trivy",
      "version": "2.41-12+deb13u2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "MEDIUM"
  },
  {
    "package": {
      "name": "CVE-2026-4878",
      "link": "https://avd.aquasec.com/nvd/cve-2026-4878",
      "package": "libcap2",
      "source": "trivy",
      "version": "1:2.75-10+b8",
      "origin": "os",
      "type": "debian"
    },
    "severity": "MEDIUM"
  },
  {
    "package": {
      "name": "CVE-2026-27456",
      "link": "https://avd.aquasec.com/nvd/cve-2026-27456",
      "package": "liblastlog2-2",
      "source": "trivy",
      "version": "2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "MEDIUM"
  },
  {
    "package": {
      "name": "CVE-2026-34743",
      "link": "https://avd.aquasec.com/nvd/cve-2026-34743",
      "package": "liblzma5",
      "source": "trivy",
      "version": "5.8.1-1",
      "origin": "os",
      "type": "debian"
    },
    "severity": "MEDIUM"
  },
  {
    "package": {
      "name": "CVE-2026-27456",
      "link": "https://avd.aquasec.com/nvd/cve-2026-27456",
      "package": "libmount1",
      "source": "trivy",
      "version": "2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "MEDIUM"
  },
  {
    "package": {
      "name": "CVE-2026-27456",
      "link": "https://avd.aquasec.com/nvd/cve-2026-27456",
      "package": "libsmartcols1",
      "source": "trivy",
      "version": "2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "MEDIUM"
  },
  {
    "package": {
      "name": "CVE-2026-40225",
      "link": "https://avd.aquasec.com/nvd/cve-2026-40225",
      "package": "libsystemd0",
      "source": "trivy",
      "version": "257.9-1~deb13u1",
      "origin": "os",
      "type": "debian"
    },
    "severity": "MEDIUM"
  },
  {
    "package": {
      "name": "CVE-2026-40226",
      "link": "https://avd.aquasec.com/nvd/cve-2026-40226",
      "package": "libsystemd0",
      "source": "trivy",
      "version": "257.9-1~deb13u1",
      "origin": "os",
      "type": "debian"
    },
    "severity": "MEDIUM"
  },
  {
    "package": {
      "name": "CVE-2026-4105",
      "link": "https://avd.aquasec.com/nvd/cve-2026-4105",
      "package": "libsystemd0",
      "source": "trivy",
      "version": "257.9-1~deb13u1",
      "origin": "os",
      "type": "debian"
    },
    "severity": "MEDIUM"
  },
  {
    "package": {
      "name": "CVE-2026-40225",
      "link": "https://avd.aquasec.com/nvd/cve-2026-40225",
      "package": "libudev1",
      "source": "trivy",
      "version": "257.9-1~deb13u1",
      "origin": "os",
      "type": "debian"
    },
    "severity": "MEDIUM"
  },
  {
    "package": {
      "name": "CVE-2026-40226",
      "link": "https://avd.aquasec.com/nvd/cve-2026-40226",
      "package": "libudev1",
      "source": "trivy",
      "version": "257.9-1~deb13u1",
      "origin": "os",
      "type": "debian"
    },
    "severity": "MEDIUM"
  },
  {
    "package": {
      "name": "CVE-2026-4105",
      "link": "https://avd.aquasec.com/nvd/cve-2026-4105",
      "package": "libudev1",
      "source": "trivy",
      "version": "257.9-1~deb13u1",
      "origin": "os",
      "type": "debian"
    },
    "severity": "MEDIUM"
  },
  {
    "package": {
      "name": "CVE-2026-27456",
      "link": "https://avd.aquasec.com/nvd/cve-2026-27456",
      "package": "libuuid1",
      "source": "trivy",
      "version": "2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "MEDIUM"
  },
  {
    "package": {
      "name": "CVE-2026-27456",
      "link": "https://avd.aquasec.com/nvd/cve-2026-27456",
      "package": "login",
      "source": "trivy",
      "version": "1:4.16.0-2+really2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "MEDIUM"
  },
  {
    "package": {
      "name": "CVE-2026-27456",
      "link": "https://avd.aquasec.com/nvd/cve-2026-27456",
      "package": "mount",
      "source": "trivy",
      "version": "2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "MEDIUM"
  },
  {
    "package": {
      "name": "CVE-2026-5704",
      "link": "https://avd.aquasec.com/nvd/cve-2026-5704",
      "package": "tar",
      "source": "trivy",
      "version": "1.35+dfsg-3.1",
      "origin": "os",
      "type": "debian"
    },
    "severity": "MEDIUM"
  },
  {
    "package": {
      "name": "CVE-2026-27456",
      "link": "https://avd.aquasec.com/nvd/cve-2026-27456",
      "package": "util-linux",
      "source": "trivy",
      "version": "2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "MEDIUM"
  },
  {
    "package": {
      "name": "CVE-2026-27171",
      "link": "https://avd.aquasec.com/nvd/cve-2026-27171",
      "package": "zlib1g",
      "source": "trivy",
      "version": "1:1.3.dfsg+really1.3.1-1+b1",
      "origin": "os",
      "type": "debian"
    },
    "severity": "MEDIUM"
  },
  {
    "package": {
      "name": "CVE-2011-3374",
      "link": "https://avd.aquasec.com/nvd/cve-2011-3374",
      "package": "apt",
      "source": "trivy",
      "version": "3.0.3",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "TEMP-0841856-B18BAF",
      "link": "https://security-tracker.debian.org/tracker/TEMP-0841856-B18BAF",
      "package": "bash",
      "source": "trivy",
      "version": "5.2.37-2+b8",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2022-0563",
      "link": "https://avd.aquasec.com/nvd/cve-2022-0563",
      "package": "bsdutils",
      "source": "trivy",
      "version": "1:2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2025-14104",
      "link": "https://avd.aquasec.com/nvd/cve-2025-14104",
      "package": "bsdutils",
      "source": "trivy",
      "version": "1:2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2026-3184",
      "link": "https://avd.aquasec.com/nvd/cve-2026-3184",
      "package": "bsdutils",
      "source": "trivy",
      "version": "1:2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2017-18018",
      "link": "https://avd.aquasec.com/nvd/cve-2017-18018",
      "package": "coreutils",
      "source": "trivy",
      "version": "9.7-3",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2025-5278",
      "link": "https://avd.aquasec.com/nvd/cve-2025-5278",
      "package": "coreutils",
      "source": "trivy",
      "version": "9.7-3",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2011-3374",
      "link": "https://avd.aquasec.com/nvd/cve-2011-3374",
      "package": "libapt-pkg7.0",
      "source": "trivy",
      "version": "3.0.3",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2022-0563",
      "link": "https://avd.aquasec.com/nvd/cve-2022-0563",
      "package": "libblkid1",
      "source": "trivy",
      "version": "2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2025-14104",
      "link": "https://avd.aquasec.com/nvd/cve-2025-14104",
      "package": "libblkid1",
      "source": "trivy",
      "version": "2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2026-3184",
      "link": "https://avd.aquasec.com/nvd/cve-2026-3184",
      "package": "libblkid1",
      "source": "trivy",
      "version": "2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2010-4756",
      "link": "https://avd.aquasec.com/nvd/cve-2010-4756",
      "package": "libc-bin",
      "source": "trivy",
      "version": "2.41-12+deb13u2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2018-20796",
      "link": "https://avd.aquasec.com/nvd/cve-2018-20796",
      "package": "libc-bin",
      "source": "trivy",
      "version": "2.41-12+deb13u2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2019-1010022",
      "link": "https://avd.aquasec.com/nvd/cve-2019-1010022",
      "package": "libc-bin",
      "source": "trivy",
      "version": "2.41-12+deb13u2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2019-1010023",
      "link": "https://avd.aquasec.com/nvd/cve-2019-1010023",
      "package": "libc-bin",
      "source": "trivy",
      "version": "2.41-12+deb13u2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2019-1010024",
      "link": "https://avd.aquasec.com/nvd/cve-2019-1010024",
      "package": "libc-bin",
      "source": "trivy",
      "version": "2.41-12+deb13u2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2019-1010025",
      "link": "https://avd.aquasec.com/nvd/cve-2019-1010025",
      "package": "libc-bin",
      "source": "trivy",
      "version": "2.41-12+deb13u2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2019-9192",
      "link": "https://avd.aquasec.com/nvd/cve-2019-9192",
      "package": "libc-bin",
      "source": "trivy",
      "version": "2.41-12+deb13u2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2010-4756",
      "link": "https://avd.aquasec.com/nvd/cve-2010-4756",
      "package": "libc6",
      "source": "trivy",
      "version": "2.41-12+deb13u2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2018-20796",
      "link": "https://avd.aquasec.com/nvd/cve-2018-20796",
      "package": "libc6",
      "source": "trivy",
      "version": "2.41-12+deb13u2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2019-1010022",
      "link": "https://avd.aquasec.com/nvd/cve-2019-1010022",
      "package": "libc6",
      "source": "trivy",
      "version": "2.41-12+deb13u2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2019-1010023",
      "link": "https://avd.aquasec.com/nvd/cve-2019-1010023",
      "package": "libc6",
      "source": "trivy",
      "version": "2.41-12+deb13u2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2019-1010024",
      "link": "https://avd.aquasec.com/nvd/cve-2019-1010024",
      "package": "libc6",
      "source": "trivy",
      "version": "2.41-12+deb13u2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2019-1010025",
      "link": "https://avd.aquasec.com/nvd/cve-2019-1010025",
      "package": "libc6",
      "source": "trivy",
      "version": "2.41-12+deb13u2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2019-9192",
      "link": "https://avd.aquasec.com/nvd/cve-2019-9192",
      "package": "libc6",
      "source": "trivy",
      "version": "2.41-12+deb13u2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2022-0563",
      "link": "https://avd.aquasec.com/nvd/cve-2022-0563",
      "package": "liblastlog2-2",
      "source": "trivy",
      "version": "2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2025-14104",
      "link": "https://avd.aquasec.com/nvd/cve-2025-14104",
      "package": "liblastlog2-2",
      "source": "trivy",
      "version": "2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2026-3184",
      "link": "https://avd.aquasec.com/nvd/cve-2026-3184",
      "package": "liblastlog2-2",
      "source": "trivy",
      "version": "2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2022-0563",
      "link": "https://avd.aquasec.com/nvd/cve-2022-0563",
      "package": "libmount1",
      "source": "trivy",
      "version": "2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2025-14104",
      "link": "https://avd.aquasec.com/nvd/cve-2025-14104",
      "package": "libmount1",
      "source": "trivy",
      "version": "2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2026-3184",
      "link": "https://avd.aquasec.com/nvd/cve-2026-3184",
      "package": "libmount1",
      "source": "trivy",
      "version": "2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2025-6141",
      "link": "https://avd.aquasec.com/nvd/cve-2025-6141",
      "package": "libncursesw6",
      "source": "trivy",
      "version": "6.5+20250216-2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2022-0563",
      "link": "https://avd.aquasec.com/nvd/cve-2022-0563",
      "package": "libsmartcols1",
      "source": "trivy",
      "version": "2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2025-14104",
      "link": "https://avd.aquasec.com/nvd/cve-2025-14104",
      "package": "libsmartcols1",
      "source": "trivy",
      "version": "2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2026-3184",
      "link": "https://avd.aquasec.com/nvd/cve-2026-3184",
      "package": "libsmartcols1",
      "source": "trivy",
      "version": "2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2021-45346",
      "link": "https://avd.aquasec.com/nvd/cve-2021-45346",
      "package": "libsqlite3-0",
      "source": "trivy",
      "version": "3.46.1-7+deb13u1",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2025-70873",
      "link": "https://avd.aquasec.com/nvd/cve-2025-70873",
      "package": "libsqlite3-0",
      "source": "trivy",
      "version": "3.46.1-7+deb13u1",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2013-4392",
      "link": "https://avd.aquasec.com/nvd/cve-2013-4392",
      "package": "libsystemd0",
      "source": "trivy",
      "version": "257.9-1~deb13u1",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2023-31437",
      "link": "https://avd.aquasec.com/nvd/cve-2023-31437",
      "package": "libsystemd0",
      "source": "trivy",
      "version": "257.9-1~deb13u1",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2023-31438",
      "link": "https://avd.aquasec.com/nvd/cve-2023-31438",
      "package": "libsystemd0",
      "source": "trivy",
      "version": "257.9-1~deb13u1",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2023-31439",
      "link": "https://avd.aquasec.com/nvd/cve-2023-31439",
      "package": "libsystemd0",
      "source": "trivy",
      "version": "257.9-1~deb13u1",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2026-40228",
      "link": "https://avd.aquasec.com/nvd/cve-2026-40228",
      "package": "libsystemd0",
      "source": "trivy",
      "version": "257.9-1~deb13u1",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2025-6141",
      "link": "https://avd.aquasec.com/nvd/cve-2025-6141",
      "package": "libtinfo6",
      "source": "trivy",
      "version": "6.5+20250216-2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2013-4392",
      "link": "https://avd.aquasec.com/nvd/cve-2013-4392",
      "package": "libudev1",
      "source": "trivy",
      "version": "257.9-1~deb13u1",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2023-31437",
      "link": "https://avd.aquasec.com/nvd/cve-2023-31437",
      "package": "libudev1",
      "source": "trivy",
      "version": "257.9-1~deb13u1",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2023-31438",
      "link": "https://avd.aquasec.com/nvd/cve-2023-31438",
      "package": "libudev1",
      "source": "trivy",
      "version": "257.9-1~deb13u1",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2023-31439",
      "link": "https://avd.aquasec.com/nvd/cve-2023-31439",
      "package": "libudev1",
      "source": "trivy",
      "version": "257.9-1~deb13u1",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2026-40228",
      "link": "https://avd.aquasec.com/nvd/cve-2026-40228",
      "package": "libudev1",
      "source": "trivy",
      "version": "257.9-1~deb13u1",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2022-0563",
      "link": "https://avd.aquasec.com/nvd/cve-2022-0563",
      "package": "libuuid1",
      "source": "trivy",
      "version": "2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2025-14104",
      "link": "https://avd.aquasec.com/nvd/cve-2025-14104",
      "package": "libuuid1",
      "source": "trivy",
      "version": "2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2026-3184",
      "link": "https://avd.aquasec.com/nvd/cve-2026-3184",
      "package": "libuuid1",
      "source": "trivy",
      "version": "2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2022-0563",
      "link": "https://avd.aquasec.com/nvd/cve-2022-0563",
      "package": "login",
      "source": "trivy",
      "version": "1:4.16.0-2+really2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2025-14104",
      "link": "https://avd.aquasec.com/nvd/cve-2025-14104",
      "package": "login",
      "source": "trivy",
      "version": "1:4.16.0-2+really2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2026-3184",
      "link": "https://avd.aquasec.com/nvd/cve-2026-3184",
      "package": "login",
      "source": "trivy",
      "version": "1:4.16.0-2+really2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2007-5686",
      "link": "https://avd.aquasec.com/nvd/cve-2007-5686",
      "package": "login.defs",
      "source": "trivy",
      "version": "1:4.17.4-2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2024-56433",
      "link": "https://avd.aquasec.com/nvd/cve-2024-56433",
      "package": "login.defs",
      "source": "trivy",
      "version": "1:4.17.4-2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "TEMP-0628843-DBAD28",
      "link": "https://security-tracker.debian.org/tracker/TEMP-0628843-DBAD28",
      "package": "login.defs",
      "source": "trivy",
      "version": "1:4.17.4-2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2022-0563",
      "link": "https://avd.aquasec.com/nvd/cve-2022-0563",
      "package": "mount",
      "source": "trivy",
      "version": "2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2025-14104",
      "link": "https://avd.aquasec.com/nvd/cve-2025-14104",
      "package": "mount",
      "source": "trivy",
      "version": "2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2026-3184",
      "link": "https://avd.aquasec.com/nvd/cve-2026-3184",
      "package": "mount",
      "source": "trivy",
      "version": "2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2025-6141",
      "link": "https://avd.aquasec.com/nvd/cve-2025-6141",
      "package": "ncurses-base",
      "source": "trivy",
      "version": "6.5+20250216-2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2025-6141",
      "link": "https://avd.aquasec.com/nvd/cve-2025-6141",
      "package": "ncurses-bin",
      "source": "trivy",
      "version": "6.5+20250216-2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2007-5686",
      "link": "https://avd.aquasec.com/nvd/cve-2007-5686",
      "package": "passwd",
      "source": "trivy",
      "version": "1:4.17.4-2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2024-56433",
      "link": "https://avd.aquasec.com/nvd/cve-2024-56433",
      "package": "passwd",
      "source": "trivy",
      "version": "1:4.17.4-2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "TEMP-0628843-DBAD28",
      "link": "https://security-tracker.debian.org/tracker/TEMP-0628843-DBAD28",
      "package": "passwd",
      "source": "trivy",
      "version": "1:4.17.4-2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2011-4116",
      "link": "https://avd.aquasec.com/nvd/cve-2011-4116",
      "package": "perl-base",
      "source": "trivy",
      "version": "5.40.1-6",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "TEMP-0517018-A83CE6",
      "link": "https://security-tracker.debian.org/tracker/TEMP-0517018-A83CE6",
      "package": "sysvinit-utils",
      "source": "trivy",
      "version": "3.14-4",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2005-2541",
      "link": "https://avd.aquasec.com/nvd/cve-2005-2541",
      "package": "tar",
      "source": "trivy",
      "version": "1.35+dfsg-3.1",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "TEMP-0290435-0B57B5",
      "link": "https://security-tracker.debian.org/tracker/TEMP-0290435-0B57B5",
      "package": "tar",
      "source": "trivy",
      "version": "1.35+dfsg-3.1",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2022-0563",
      "link": "https://avd.aquasec.com/nvd/cve-2022-0563",
      "package": "util-linux",
      "source": "trivy",
      "version": "2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2025-14104",
      "link": "https://avd.aquasec.com/nvd/cve-2025-14104",
      "package": "util-linux",
      "source": "trivy",
      "version": "2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2026-3184",
      "link": "https://avd.aquasec.com/nvd/cve-2026-3184",
      "package": "util-linux",
      "source": "trivy",
      "version": "2.41-5",
      "origin": "os",
      "type": "debian"
    },
    "severity": "LOW"
  },
  {
    "package": {
      "name": "CVE-2026-5958",
      "link": "https://avd.aquasec.com/nvd/cve-2026-5958",
      "package": "sed",
      "source": "trivy",
      "version": "4.9-2",
      "origin": "os",
      "type": "debian"
    },
    "severity": "UNDEFINED"
  }
]

# Задача 3

<img width="1226" height="839" alt="Снимок экрана 2026-04-26 185831" src="https://github.com/user-attachments/assets/c2fad873-9342-4b5c-a340-c3840a5b78f8" />

**SQL-запрос**

# Задача 4

<img width="1106" height="891" alt="image" src="https://github.com/user-attachments/assets/305169e8-d272-4e39-8a16-d31ac4857ea9" />

**Проверка доступности сервиса**

<img width="1595" height="180" alt="image" src="https://github.com/user-attachments/assets/33041a35-307e-421e-97b2-d6ff72addfca" />

**Настроенный context и проверка контейнеров**

<img width="717" height="919" alt="image" src="https://github.com/user-attachments/assets/dd640e38-e63a-4ed7-9e6b-a7e00bf1a237" />

**SQL-запрос**

Ссылка на fork: https://github.com/MustWay-byte/shvirtd-example-python

# Задача 5

Ссылка на скрипт: https://github.com/MustWay-byte/shvirtd-example-python/blob/main/backup.sh

<img width="1060" height="476" alt="image" src="https://github.com/user-attachments/assets/7af27e4d-1977-48f0-8fb0-eee99678f43b" />

**Настройка Crontab**

<img width="1110" height="57" alt="image" src="https://github.com/user-attachments/assets/85b5d126-2e4c-464f-a3c3-0ca2ddb2276c" />

**Список резервных копий**

# Задача 6

# Задача 6.1

# Задача 6.2

# Задача 7
