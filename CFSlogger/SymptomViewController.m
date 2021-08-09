//
//  SymptomViewController.m
//  MECFSJournal
//
//  Created by Arturo Plottier on 15/02/2014.
//  Copyright (c) 2014 pac-apps. All rights reserved.
//

#import "SymptomViewController.h"

@interface SymptomViewController ()

@end

@implementation SymptomViewController
@synthesize symptomPicker, symType, AC, AP, BV, CC, CNS, CP, DATXT, DMD, DME, DV, DWN, EPS, FA, FB, FC, FCA, FD, SIZ, SB, SF, SL, SS, ST, STN,HA, HWD, IB, IH, IS, LGF, LH, LMS, MJP, MLBF, NS, NTS, PJ, RD, RF, RIE, RIF, RS, TSLN, URF, VOM, Recorddata, SymptomTitleTXT;

- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
       Recorddata.Severity = symptomTypes[row];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
       return [symptomTypes count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
        return symptomTypes[row];
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    [DATXT resignFirstResponder];
    [SymptomTitleTXT resignFirstResponder];

}

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/
/*
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self sendMail];
            break;
        case 1:
            [self performSegueWithIdentifier:@"searchSegue" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"aboutSegue" sender:self];
            break;
        default:
            break;
    }
    
}
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
    symptomTypes = @[@"Mild", @"Moderate",
                     @"Severe"];
    //Recorddata.SymptomDesc = @"";
    //Recorddata.SymptomName = @"";
    //Recorddata.SymptomTitle = @"";
/*
    if (Recorddata.SymId > 0)
    {
        
        CFSRecord *SymptomFields =  (CFSRecord *)[[CFSDB database] getAllSymptoms:Recorddata.ActId];
        Recorddata.SymId = SymptomFields.SymId;
        Recorddata.SDateId = SymptomFields.SDateId;
        Recorddata.SymptomDesc = SymptomFields.SymptomDesc;
        Recorddata.SymptomName = SymptomFields.SymptomName;
        Recorddata.SymptomTitle = SymptomFields.SymptomTitle;
        Recorddata.Severity = SymptomFields.Severity;
        */
             int b = 0;
        for(id a in symptomTypes)
        {
            
            if ([a isEqualToString:Recorddata.Severity])
            {
                [symptomPicker selectRow:b inComponent:0 animated:YES];
            }
            b = b + 1;
        }
    if ([Recorddata.Severity isEqualToString:@""])
        Recorddata.Severity = symptomTypes[0];
    
    

 //       DATXT.text = Recorddata.SymptomDesc;
    if (Recorddata.SymptomName.length > 0)
    {
    NSArray* symptoms = [Recorddata.SymptomName componentsSeparatedByString: @";"];
    if ([[symptoms objectAtIndex: 0] length] > 1) HA.on = YES;
    if ([[symptoms objectAtIndex: 1] length] > 1) LMS.on = YES;
    if ([[symptoms objectAtIndex: 2] length] > 1) MJP.on = YES;
    if ([[symptoms objectAtIndex: 3] length] > 1) URF.on = YES;
    if ([[symptoms objectAtIndex: 4] length] > 1) ST.on = YES;
    if ([[symptoms objectAtIndex: 5] length] > 1) SF.on = YES;
    if ([[symptoms objectAtIndex: 6] length] > 1) SIZ.on = YES;
    if ([[symptoms objectAtIndex: 7] length] > 1) FA.on = YES;
    if ([[symptoms objectAtIndex: 8] length] > 1) DV.on = YES;
    if ([[symptoms objectAtIndex: 9] length] > 1) IH.on = YES;
    
    if ([[symptoms objectAtIndex: 10] length] > 1) LH.on = YES;
    if ([[symptoms objectAtIndex: 11] length] > 1) SB.on = YES;
    if ([[symptoms objectAtIndex: 12] length] > 1) CP.on = YES;
    if ([[symptoms objectAtIndex: 13] length] > 1) AP.on = YES;
    if ([[symptoms objectAtIndex: 14] length] > 1) FB.on = YES;
    if ([[symptoms objectAtIndex: 15] length] > 1) FC.on = YES;
    if ([[symptoms objectAtIndex: 16] length] > 1) FCA.on = YES;
    if ([[symptoms objectAtIndex: 17] length] > 1) FD.on = YES;
    if ([[symptoms objectAtIndex: 18] length] > 1) IB.on = YES;
    if ([[symptoms objectAtIndex: 19] length] > 1) RF.on = YES;
    
    if ([[symptoms objectAtIndex: 20] length] > 1) VOM.on = YES;
    if ([[symptoms objectAtIndex: 21] length] > 1) AC.on = YES;
    if ([[symptoms objectAtIndex: 22] length] > 1) DMD.on = YES;
    if ([[symptoms objectAtIndex: 23] length] > 1) DWN.on = YES;
    if ([[symptoms objectAtIndex: 24] length] > 1) HWD.on = YES;
    if ([[symptoms objectAtIndex: 25] length] > 1) IS.on = YES;
    if ([[symptoms objectAtIndex: 26] length] > 1) MLBF.on = YES;
    if ([[symptoms objectAtIndex: 27] length] > 1) PJ.on = YES;
    if ([[symptoms objectAtIndex: 28] length] > 1) RD.on = YES;
    if ([[symptoms objectAtIndex: 29] length] > 1) SS.on = YES;
    
    if ([[symptoms objectAtIndex: 30] length] > 1) BV.on = YES;
    if ([[symptoms objectAtIndex: 31] length] > 1) DME.on = YES;
    if ([[symptoms objectAtIndex: 32] length] > 1) EPS.on = YES;
    if ([[symptoms objectAtIndex: 33] length] > 1) NTS.on = YES;
    if ([[symptoms objectAtIndex: 34] length] > 1) RIE.on = YES;
    if ([[symptoms objectAtIndex: 35] length] > 1) SL.on = YES;
    if ([[symptoms objectAtIndex: 36] length] > 1) STN.on = YES;
        
    if ([[symptoms objectAtIndex: 37] length] > 1) CC.on = YES;
    if ([[symptoms objectAtIndex: 38] length] > 1) CNS.on = YES;
    if ([[symptoms objectAtIndex: 39] length] > 1) LGF.on = YES;
    if ([[symptoms objectAtIndex: 40] length] > 1) NS.on = YES;
    if ([[symptoms objectAtIndex: 41] length] > 1) RIF.on = YES;
    if ([[symptoms objectAtIndex: 42] length] > 1) RS.on = YES;
    if ([[symptoms objectAtIndex: 43] length] > 1) TSLN.on = YES;
    }
    if (Recorddata.SymptomDesc.length > 0)
        DATXT.text =  Recorddata.SymptomDesc;
    if (Recorddata.SymptomTitle.length > 0)
        SymptomTitleTXT.text =  Recorddata.SymptomTitle;

}

-(void)viewWillDisappear:(BOOL)animated
{
   // NSMutableArray *recs =  [[NSMutableArray alloc] init];
    Recorddata.SymptomName = Nil;
   
    if (HA.on)  {
        Recorddata.SymptomName = @"Headaches=Primary"; //Recorddata.SymId = Recorddata.ActId;
       // Recorddata.SDateId = Recorddata.ADateId; //[recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@""];}
        //Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];}
    if (LMS.on)  {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Loss of muscular strength=Primary", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
      //  Recorddata.SDateId = Recorddata.ADateId;
       // [recs addObject=Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];
    }
    
    if (MJP.on) {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Muscle and-or joint pain=Primary", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
      //  Recorddata.SDateId = Recorddata.ADateId; //[recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];
    }
    if (URF.on)  {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Un-refreshing sleep=Primary", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
      //  Recorddata.SDateId = Recorddata.ADateId; //[recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];
    }
    if (ST.on) {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Sore Throat=Primary", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
        //  Recorddata.SDateId = Recorddata.ADateId; //[recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];
    }
    if (SF.on)  {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Severe Fatigue=Primary", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
        //  Recorddata.SDateId = Recorddata.ADateId; //[recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];
    }

    
    
        if (SIZ.on)  {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Seizures=Neurological and cardiac", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
        //  Recorddata.SDateId = Recorddata.ADateId; //[recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];
    }
    if (FA.on)  {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Fainting=Neurological and cardiac", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
        //  Recorddata.SDateId = Recorddata.ADateId; [recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];
    }
    if (DV.on)  {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Dizziness and-or vertigo=Neurological and cardiac", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
        //  Recorddata.SDateId = Recorddata.ADateId; [recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];
    }
    if (IH.on) {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Irregular heartbeat=Neurological and cardiac", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
        // Recorddata.SDateId = Recorddata.ADateId;
        //[recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];
    }
    if (LH.on)  {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Light headedness=Neurological and cardiac", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
        //  Recorddata.SDateId = Recorddata.ADateId; //[recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];
    }
    if (SB.on) {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Shortness of Breath=Neurological and cardiac", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
        // Recorddata.SDateId = Recorddata.ADateId;
        //[recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];
    }
    if (CP.on)  {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Chest Pains=Neurological and cardiac", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
        //  Recorddata.SDateId = Recorddata.ADateId; //[recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];
    }
    
    if (AP.on) {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Abdominal Pain=Gastrointestinal", Recorddata.SymptomName];
      //  Recorddata.SymId = Recorddata.ActId; Recorddata.SDateId = Recorddata.ADateId; //[recs addObject:[Recorddata copy]];
    } else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];}
        
    if (FB.on)  {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Frequent bloating=Gastrointestinal", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
        //  Recorddata.SDateId = Recorddata.ADateId; [recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];}
    
    if (FC.on)  {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Frequent constipation=Gastrointestinal", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
        //  Recorddata.SDateId = Recorddata.ADateId; //[recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];}
    
    if (FCA.on) { Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Food cravings=Gastrointestinal", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
        //Recorddata.SDateId = Recorddata.ADateId; //[recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];}
    
    if (FD.on) { Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Frequent diarrhoea=Gastrointestinal", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
       // Recorddata.SDateId = Recorddata.ADateId; //[recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];}
    if (IB.on)  {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Irritable bowl=Gastrointestinal", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
        //  Recorddata.SDateId = Recorddata.ADateId; //[recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];
    }
    if (RF.on)  {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Reflux=Gastrointestinal", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
        //  Recorddata.SDateId = Recorddata.ADateId; //[recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];
    }
    if (VOM.on) {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Vomiting=Gastrointestinal", Recorddata.SymptomName];// Recorddata.SymId = Recorddata.ActId;
        //  Recorddata.SDateId = Recorddata.ADateId; //[recs addObject:Recorddata];
    }
    else{
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];
    }
    if (AC.on) {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Appetite Changes=Gastrointestinal", Recorddata.SymptomName];// Recorddata.SymId = Recorddata.ActId;
        //  Recorddata.SDateId = Recorddata.ADateId; //[recs addObject:Recorddata];
    }
    else{
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];
    }

    
    if (DMD.on)  {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Difficulty making decisions=Cognitive", Recorddata.SymptomName];//Recorddata.SymId =
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];}
    

    if (DWN.on) {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Difficulty with numbers=Cognitive", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
        // Recorddata.SDateId = Recorddata.ADateId; [recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];}
        
    if (HWD.on) {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Hand writing difficulty=Cognitive", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
        // Recorddata.SDateId = Recorddata.ADateId; //[recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];}
    
    
    
    if (IS.on) {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Impairment of speech=Cognitive", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
        // Recorddata.SDateId = Recorddata.ADateId;
        //[recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];
    }
    if (MLBF.on)  {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Memory loss or brain fog=Cognitive", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
        //   Recorddata.SDateId = Recorddata.ADateId;
        //[recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];
    }
    if (PJ.on) {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Poor judgement=Cognitive", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
        //  Recorddata.SDateId = Recorddata.ADateId;
        // [recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];
    }
    
    if (RD.on)  {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Reading difficulty=Cognitive", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
        // Recorddata.SDateId = Recorddata.ADateId;
        //[recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];
    }
    if (SS.on)  {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Slowed Speech=Cognitive", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
        // Recorddata.SDateId = Recorddata.ADateId;
        //[recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];
    }
    if (BV.on)  {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Blurred Vision=Sensory", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
        //  Recorddata.SDateId = Recorddata.ADateId; [recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];}
    if (DME.on)  {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Dryness of the mouth and eyes=Sensory", Recorddata.SymptomName];// Recorddata.SymId = Recorddata.ActId;
        //  Recorddata.SDateId = Recorddata.ADateId; [recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];}
    
    
    if (EPS.on) {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Eye pain - spasms=Sensory", Recorddata.SymptomName];// Recorddata.SymId = Recorddata.ActId;
        //  Recorddata.SDateId = Recorddata.ADateId; [recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];}
    if (NTS.on)  {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Numbness or tingling sensations=Sensory", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
        //  Recorddata.SDateId = Recorddata.ADateId;
        //[recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];
    }
    
    
    if (RIE.on)  {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Ringing in the ears=Sensory", Recorddata.SymptomName];// Recorddata.SymId = Recorddata.ActId;
        // Recorddata.SDateId = Recorddata.ADateId; //[recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];
    }
    if (SL.on)  {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Sensitive to Light=Sensory", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
        //  Recorddata.SDateId = Recorddata.ADateId;
        //[recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];
    }
    
    
    if (STN.on)  {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Sensitive to Noise=Sensory", Recorddata.SymptomName];// Recorddata.SymId = Recorddata.ActId;
        // Recorddata.SDateId = Recorddata.ADateId; //[recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];
    }

    
    if (CC.on) {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Chronic cough=Flu like", Recorddata.SymptomName];// Recorddata.SymId = Recorddata.ActId;
        // Recorddata.SDateId = Recorddata.ADateId; [recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];}
    
    if (CNS.on)  {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Chills and night sweat=Flu like", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
        // Recorddata.SDateId = Recorddata.ADateId; [recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];}
    if (LGF.on)  {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Low grade fever=Flu like", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
        // Recorddata.SDateId = Recorddata.ADateId;// [recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];
    }
    if (NS.on) {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Nausea=Flu like", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
        //  Recorddata.SDateId = Recorddata.ADateId;
        //[recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];
    }
    
    
    if (RIF.on){
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Recurrent infections and-or flu=Flu like", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
        // Recorddata.SDateId = Recorddata.ADateId; //[recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];
    }
    
    if (RS.on)  {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Rash=Flu like", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
        //  Recorddata.SDateId = Recorddata.ADateId; //[recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];
    }

    if (TSLN.on)  {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@;Tender or swollen lymph nodes=Flu like", Recorddata.SymptomName]; //Recorddata.SymId = Recorddata.ActId;
        //   Recorddata.SDateId = Recorddata.ADateId; //[recs addObject:Recorddata];
    }
    else {
        Recorddata.SymptomName = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomName];
    }
   
   /*
    if (DATXT.text.length > 0) {
        Recorddata.SymptomDesc = [NSString stringWithFormat:@"%@;TEXT=TEXT", Recorddata.SymptomDesc];
    }
    else {
        Recorddata.SymptomDesc = [NSString stringWithFormat:@"%@; ", Recorddata.SymptomDesc];
    }
*/

    Recorddata.SymptomDesc = DATXT.text;
    Recorddata.SymptomTitle = SymptomTitleTXT.text;

    //[recs addObject:Recorddata];
  
    
    
    /*
    CFSDB *nad = [[CFSDB alloc]init];
    
    if (Recorddata.SymId < 1)
        Recorddata.SymId = [nad insertSymptom:Recorddata];
    else if (Recorddata.SymId > 0)
        [nad updateSymptoms:Recorddata];
*/
  }

-(IBAction) popButton:(id) sender
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: nil
                                                                        message: nil
                                                                 preferredStyle: UIAlertControllerStyleActionSheet];
    
    UIAlertAction *share = [UIAlertAction actionWithTitle: @"Share"
                                                    style: UIAlertActionStyleDefault
                                                  handler: ^(UIAlertAction *action) {
                                                      [self sendMail];
                                                  }];
    UIAlertAction *search = [UIAlertAction actionWithTitle: @"Search"
                                                     style: UIAlertActionStyleDefault
                                                   handler: ^(UIAlertAction *action) {
                                                       [self performSegueWithIdentifier:@"searchSegue" sender:self];
                                                   }];
    
    UIAlertAction *aboutus = [UIAlertAction actionWithTitle: @"About us"
                                                      style: UIAlertActionStyleDefault
                                                    handler: ^(UIAlertAction *action) {
                                                        [self performSegueWithIdentifier:@"aboutSegue" sender:self];
                                                    }];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle: @"Cancel" style: UIAlertActionStyleDefault handler: nil];
  //  UIBarButtonItem *button;
    [controller addAction: share];
    [controller addAction: search];
    [controller addAction: aboutus];
    [controller addAction: cancel];
    if ([[UIDevice currentDevice].model rangeOfString:@"Pad"].location != NSNotFound) {
        controller.popoverPresentationController.sourceView = self.view;
        controller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0); //[sender bounds];
    }
    
    [self presentViewController: controller animated: YES completion: nil];
    /*
    UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"cancel"  destructiveButtonTitle:nil otherButtonTitles:@"share", @"search",@"about us", nil];
    // [ac setTintColor:[UIColor blackColor]];
    ac.actionSheetStyle = UIBarStyleBlack;
    [ac showInView:self.view];
    */
}
-(void) sendMail{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        [mailController setMailComposeDelegate:self];
        [mailController setMessageBody:@"Check this app out at " cfsonline isHTML:NO];
        [self presentViewController:mailController animated:YES completion:nil];
    }
    else
    {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Email account"
                                                                            message: @"No email account found"
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle: @"Ok" style: UIAlertActionStyleDefault handler: nil];
        
        [controller addAction: ok];
        [self presentViewController: controller animated: YES completion: nil];
        // NSLog(@"Unable to send email");
        /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"email account" message:@"No email account found"
                                                       delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
         */
    }
}

- (IBAction)dismissKeyboard:(id)sender {
    [DATXT resignFirstResponder];
    [SymptomTitleTXT resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textViewDidBeginEditing:(UITextView *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textField
{
    [self animateTextField:textField up:NO];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

-(void)animateTextField:(UITextView*)textField up:(BOOL)up
{
    const int movementDistance = -250; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

@end
