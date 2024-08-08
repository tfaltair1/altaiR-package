%macro wavinit;

* Macro Variables for Wavelet Specification;
    %global boundary zeroExtension periodic polynomial
        reflection antisymmetricReflection;
    %let boundary = 1;
    %let zeroExtension = 0;
    %let periodic = 1;
    %let polynomial = 2;
    %let reflection = 3;
    %let antisymmetricReflection = 4;

    %global degree constant linear quadratic;
    %let degree = 2;
    %let constant = 0;
    %let linear = 1;
    %let quadratic = 2;

    %global family daubechies symmlet;
    %let family = 3;
    %let daubechies = 1;
    %let symmlet = 2;

    %global member;
    %let member = 4;

* Macro variables for Threshold Specification;
    %global policy none hard soft garrote;
    %let policy = 1;
    %let none = 0;
    %let hard = 1;
    %let soft = 2;
    %let garrote = 3;

    %global method absolute minimax universal sure
        sureHybrid nhoodCoeffs;
    %let method = 2;
    %let absolute = 0;
    %let minimax = 1;
    %let universal = 2;
    %let sure = 3;
    %let sureHybrid = 4;
    %let nhoodCoeffs = 5;

    %global value levels all;
    %let value = 3;
    %let levels = 4;
    %let all = -1;

* Symbolic Names for the Third Argument of WAVGET;
    %global numPoints detailCoeffs scalingCoeffs
        thresholdingStatus specification topLevel
        startLevel fatherWavelet;
    %let numPoints = 1;
    %let detailCoeffs = 2;
    %let scalingCoeffs = 3;
    %let thresholdingStatus = 4;
    %let specification = 5;
    %let topLevel = 6;
    %let startLevel = 7;
    %let fatherWavelet = 8;

* Macro Variables for the Second Argument of WAVPRINT;
    %global summary detailCoeffs scalingCoeffs
        thresholdedDetailCoeffs;
    %let summary = 1;
    %let detailCoeffs = 2;
    %let scalingCoeffs = 3;
    %let thresholdedDetailCoeffs = 4;

* Macro Variables for Predefined Wavelet Specifications;
    %global waveSpec haar daubechies3 daubechies5 symmlet5
        symmlet8;
    %let waveSpec = { . . . .};
    %let haar = {&periodic . &daubechies 1 };
    %let daubechies3 = {&periodic . &daubechies 3 };
    %let daubechies5 = {&periodic . &daubechies 5 };
    %let symmlet5 = {&periodic . &symmlet 5};
    %let symmlet8 = {&periodic . &symmlet 8};

* Macro Variables for Predefined threshold Sepcifications;
    %global threshSpec RiskShrink VisuShrink SureShrink;
    %let threshSpec = {. . . .};
    %let RiskShrink = {&hard &minimax . &all};
    %let VisuShrink = {&soft &universal . &all};
    %let SureShrink = {&soft &sureHybrid . &all};

%mend wavinit;
