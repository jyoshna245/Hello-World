/*
    Author           : Accenture
    Date Created     : 05/15/2012
    Description      : This class is used as a wrapper for button properties which is passed to Visualforce component
                       for rendering over RFAActionButtons page.    
    Extends          : RFA_AP07_PageButtonWrapper
    Version History  : 1.0
*/

public class RFA_AP07_PageButtonWrapper
    {
        public String buttonlabel{get;set;}
        
        public String target{get;set;}
        
        public boolean isRendered{get;set;}
        
        public boolean confirm{get;set;}
  
        
        // overloaded constructor for the class
        public RFA_AP07_PageButtonWrapper(String buttonlabel, String target, Boolean isRendered, boolean confirm)
        {
            this.buttonlabel = buttonlabel;
            this.target = target;
            this.isRendered = isRendered;
            this.confirm = confirm;
        }
     
        
    }