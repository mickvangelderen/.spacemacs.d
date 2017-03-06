# .spacemacs.d

This repository contains my spacemacs configuration :+1:.

## External dependencies

Some packages have external dependencies. Some are listed here.

### [Source Code Pro](https://github.com/adobe-fonts/source-code-pro)

```bash
# Download the font.
wget https://github.com/adobe-fonts/source-code-pro/archive/2.030R-ro/1.050R-it.tar.gz
# Extract the font to the system font directory.
sudo tar -xzf 1.050R-it.tar.gz -C /usr/share/fonts
# Rediscover fonts.
sudo fc-cache
# Delete downloaded archive.
rm 1.050R-it.tar.gz
```

### [javascript](http://spacemacs.org/layers/+lang/javascript/README.html)

```bash
npm install --global tern
npm install --global eslint
```

### [editorconfig](http://editorconfig.org/)

```bash
sudo apt-get install editorconfig
```
