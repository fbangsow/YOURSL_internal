public class GanttChart {
        /* **************************************************************
// Creater: Alexander Faust
// Description: Controller for VFPage containing the GanttChart javascript for campaign visualization
// Testclass: N/A (yet)
// Apex Class Access: no limitations
// Last modified by: Alexander Faust
// Last modified date: 07.11.2012
// Latests changes: -changed some filter options
// ************************************************************** */
        
        public String sSelectedFilter{get;set;}
        
        //Controller
        public GanttChart(){
        
            sSelectedFilter = '2015HY1';
                
        }//END public GanttChart()
        
        //get filteroptions for javascript query to filter output of ganttchart
        public List<SelectOption> getFilterOptions(){
                List<SelectOption> listResult = new List<SelectOption>();
                
                //listResult.add(new SelectOption('2014','FY 14/15 (01.07.2014-30.06.2015)'));                
                //listResult.add(new SelectOption('2015','FY 15/16 (01.07.2015-30.06.2016)'));
                //listResult.add(new SelectOption('2016','FY 16/17 (01.07.2016-30.06.2017)'));

                listResult.add(new SelectOption('2014HY2','01.07.14-31.12.14'));                
                listResult.add(new SelectOption('2015HY1','01.01.15-30.06.15'));
                listResult.add(new SelectOption('2015HY2','01.07.15-31.12.15'));
                listResult.add(new SelectOption('2016HY1','01.01.16-30.06.16'));                
                listResult.add(new SelectOption('2016HY2','01.07.16-31.12.16'));
                
                return listResult;
        }
        
        public static testmethod  void myUnitTest(){
                GanttChart gantt = new GanttChart();
                
                gantt.getFilterOptions();
        }
}