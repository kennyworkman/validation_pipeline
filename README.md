# Colony Visualization Tool 

This project was designed to automate the colony screening process after sequencing. Using this tool, users can expect to have minimal engagement with IGV or similar manual screening GUIs. 

After cloning this repository, a command line command needs to be issued to make the bash script executable. Calling this executable with the desired/correct parameters will populate and open an excel file with a visualization of colony sequence quality. 

## QuickStart

Type the following commands into your terminal to run this script.

```bash
git clone https://github.com/kennyworkman/visual_pipeline.git
cd visual_pipeline
chmod +x visualize
bash visualize -d <insert path to directory here> -n <insert optional filename keyword here> -t <insert optional depth threshold here>
```

The script should then run and automatically open the excel file with your results when it has finished. 

## Option Flags and Default Values

```bash
-d <insert path to directory here>
```
This option is required. Copy and paste the full path to the desired directory after this flag.

```bash
-n <insert optional filename keyword here> 
```
This option is not required. If nothing is passed, the script will only parse files with 'JGI' in them by default.

```bash
-t <insert optional depth threshold here> 
```
This option is not required. If nothing is passed, the script will calculate a depth score for each colony based on a default threshold of 30.

## Sample Commands

```bash
bash visualize -d /Volumes/BaseCalls/Alignment2 -n Kenny -t 25
```
This sample command will parse any .vcf/.bam file within the "Alignment 2" directory with  the "Kenny" substring embedded in the filename. The depthscore used to filter valid colonies will be calculated with a threshold of 25.
