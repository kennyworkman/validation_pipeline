# Colony Visualization Tool 

This project was designed to automate the colony screening process after sequencing. Using this tool, users can expect to have minimal to no engagement with IGV or similar manual screening GUIs. 

After cloning this repository, a command line command needs to be issued to make the bash script executable. Calling this executable with the desired/correct parameters will populate and open an excel file with a visualization of colony sequence quality. 

## QuickStart

Type the following commands into your terminal to run this script.

```
git clone https://github.com/kennyworkman/visual_pipeline.git
cd visual_pipeline
chmod +x validate
bash validate -d <insert path to directory here> -t <insert optional depth threshold here>
```

The script should then run and automatically open the excel file with your results when it has finished. 
