/**
 * Copyright (c) 2013, Andrew Fawcett
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, 
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, 
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, 
 *      this list of conditions and the following disclaimer in the documentation 
 *      and/or other materials provided with the distribution.
 * - Neither the name of the Andrew Fawcett, nor the names of its contributors 
 *      may be used to endorse or promote products derived from this software without 
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

public with sharing class RollupScheduledCalculateController 
{
    private ApexPages.StandardController standardController;
    public String masterObjectWhere { get; set; }
    
    public RollupScheduledCalculateController (ApexPages.StandardController standardController)
    {
        this.standardController = standardController;
        
        // Page load messages
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Clicking the Schedule Calculate Job will schedule a recurring background rebuild for this rollup only.'));
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'The Calculate job will run at 2am every day.'));
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Once the job completes any failed rollups will be shown in the Rollup Summary Logs tab.'));
    }
    
    public PageReference scheduleCalculateJob()
    {
        try
        {
            // Kickoff the calculate job for this lookup
            System.schedule('rollup_'+standardController.getId(), '0 0 2 * * ?', new RollupCalculateJobSchedulable(standardController.getId(), masterObjectWhere));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Calculate job scheduled for this lookup.'));
        }
        catch (Exception e)
        {
            ApexPages.addMessages(e);
            return null;
        }
        return standardController.view();
    }
}