# Půjčovadlo (frontend)

Autor: Bc. Jaroslav Fikar (fikarja3@fit.cvut.cz)

Půjčovadlo je mobilní aplikace, která umožňuje peer-to-peer sdílení věcí mezi uživateli.

## Informace o aplikaci

Celý systém se skládá z backendové části a mobilní klientské aplikace.

Mobilní aplikace je napsána v jazyce Dart s využitím frameworku Flutter.

## Požadavky

- Flutter SDK (instalace viz [dokumentace](https://flutter-ko.dev/get-started/install))
- Android SDK (instalace
  viz [dokumentace](https://developer.android.com/tools/releases/platform-tools))
- XCode (pouze pro sestavení pro iOS, dostupné pouze pro macOS, instalace
  viz [dokumentace](https://developer.apple.com/xcode/)

## Požadavky na zařízení

- Android API 25 nebo vyšší
- iOS 14 nebo vyšší

## Spuštění aplikace

Pro spuštění aplikace je třeba mít k počítači připojené fyzické zařizení s povoelným USB laděním
nebo emulátor/simulátor.

1. Nejprve je třeba vytvořit v kořenovém adresáři soubor `.env` (např. zkopírováním
   souboru `.env.example`).
1. Je třeba nastavit proměnnou `API_URL` na adresu backendové části aplikace. Máme dvě možnosti jak
   přistoupit k lokálně běžícímu backendu:
   1. Pokud máme možnost využít nástroj Ngrok, můžeme pro přístup k lokálnímu backendu využít
      veřejnou URL adresu, kterou nám Ngrok poskytne.
      Pro využití této možnosti je třeba provést příslušné kroky popsané v
      repozitáři [PůjčovadloServer](https://github.com/Jara92/PujcovadloServer).

   1. Použitím lokálních adres:
      - Android emulátor: 10.0.2.2 nebo 10.0.3.2 (záleží na konkrétním emulátoru)
      - iOS simulátor: umožňuje přístup k hostitelskému zařízení pomocí `localhost` nebo
        adresy `127.0.0.1`
      - Fyzické zařízení: IP adresa hostitelského zařízení v lokální síti

1. Instalace potřebných balíčků a závislostí by měla proběhnout automaticky při prvním spuštění
   aplikace.
1. Aplikaci je možné spustit příkazem:

```bash
    flutter run
```

V případě, že je k dispozici více možných zařízení, je třeba specifikovat, na kterém z nich má být
aplikace spuštěna.

Zařízení lze vybrat rovnou pomocí přepínáře `-d` následovaného ID zařízení.
ID zařízení lze zjistit pomocí příkazu `flutter devices`.
Spuštění aplikace je pak možné následovně:

```bash
    flutter run -d <device_id>
```

