# 🎓 Seminar: Coding in Positron with AI - Stata Demo

This repository contains example code demonstrating features offered by Positron and other IDEs for data science and analysis using Stata.

## 📋 What This Demo Covers

This demonstration follows a complete workflow:

- 📂 Takes old analysis in Stata that used to run before
- 🧹 Cleans, restructures, and checks all the files
- ▶️ Enables re-running the analysis
- 📊 Improves it by creating additional maps in R
- ✅ Follows reproducibility guidelines to create a reproducible package

## 📚 Reproducibility Resources

- 📖 [Overall guidelines](https://worldbank.github.io/wb-reproducible-research-repository/guidance_note_wb.html)
- 📝 [README guidelines](https://github.com/worldbank/wb-reproducible-research-repository/blob/main/resources/README_Template.md)
- ☑️ [Reproducibility checklist](https://github.com/worldbank/wb-reproducible-research-repository/blob/main/reproducibility_package_checklist.md)

## 🚀 Getting Started

### Prerequisites

- 📖 [Seminar materials](https://wbggeopov.github.io/geoPovLearn/seminars/seminar-2026-02/overview.html)
- 🎥 Step-by-step video _(Coming soon)_
- 📊 [Seminar presentation](https://wbggeopov.github.io/geoPovLearn/seminars/seminar-2026-02/slides.html#/)
- 🔧 [Setup instructions](https://wbggeopov.github.io/geoPovLearn/seminars/seminar-2026-02/setup-instructions.html)

## 💻 Repository

The complete code is available on GitHub:  
🔗 https://github.com/wb532966/seminar-coding-with-ai-demo

## Example prompting

### Step 1. Understand the code and be able to reproduce it as is.

> What is the purpose of this code? What does it do? What is its structure: inputs, intermediate files, output.

> Analyze the quality of code. What are the weaknesses and how to improve them? 

> (Optional) Walk me through the code in this project? Explain what it does, how scripts connect, and which file contains the entry point or main execution logic. What data files are used and how. What outputs are produced. 

### Step 2. Restructure it so it is clear and easy to understand

> How exactly do you think the code should be improved to make this project well-structured, easy to understand, well documented and robust.

> (Optional) What recommendations could be adopted from the reproducibility guidelines here: https://worldbank.github.io/wb-reproducible-research-repository/guidance_note_wb.html ?

### Step 3. Align it with the reproducibility guidelines and document it

> Propose steps for improving this project according to your suggestions and in order to adhere to  
the reproducibility guidelines: https://worldbank.github.io/wb-reproducible-research-repository/guidance_note_wb.html. Note that: (1) I want to make data clearly structured using data/raw, data/temp, and data/processed folders. (2) Create an output folder for results, tables, and figures. (3) The code itself should be split in small logical components that are executed from the master do file. Plan those improvement steps and check with me.

> Create additional "readme.txt" that follows the guidelines: https://github.com/worldbank/wb-reproducible-research-repository/blob/main/resources/README_Template.md

> What is missing from the reproducibility checklist: https://github.com/worldbank/wb-reproducible-research-repository/blob/main/reproducibility_package_checklist.md ?


### Step 4. Add mapping using R in Agent mode

> Change the Stata code so that it produces a clear data set with subnational poverty and inequality estimates by year.

> Use R to import this data. Then find the data file with geospatial boundaries and import it too. Then report how produced poverty estimates could be matched with geospatial boundaries and combine them.

> What is the quality of this matching? Are there any regions that did not have corresponding boundaries and vice versa?

> Make maps of poverty rates by regions for two years. Combine them in one plot with two maps side by side using the same palette. Save map as png file in output.


## 📄 License

This project is licensed under the **MIT License** together with the [World Bank IGO Rider](WB-IGO-RIDER.md). The Rider is purely procedural: it reserves all privileges and immunities enjoyed by the World Bank, without adding restrictions to the MIT permissions. Please review both files before using, distributing, or contributing.

## 📬 Contact

**Eduard Bukin**  
✉️ Email: [ebukin@worldbank.org](mailto:ebukin@worldbank.org)

For bug reports, feature requests, or questions, please [🐛 open an issue](https://github.com/wb532966/seminar-coding-with-ai-demo/issues/new) on GitHub.
