classdef APA_v01_58_gm < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        GridLayout                  matlab.ui.container.GridLayout
        TabGroup                    matlab.ui.container.TabGroup
        Tab1                        matlab.ui.container.Tab
        Tab1_Grid                   matlab.ui.container.GridLayout
        DropDown_output             matlab.ui.control.DropDown
        TabsData                    matlab.ui.container.TabGroup
        Tab_Output                  matlab.ui.container.Tab
        Grid_Output                 matlab.ui.container.GridLayout
        Table_DataOut               matlab.ui.control.Table
        Tab_Input                   matlab.ui.container.Tab
        Grid_Input                  matlab.ui.container.GridLayout
        Table_DataIn                matlab.ui.control.Table
        Panel_Cuts                  matlab.ui.container.Panel
        Grid_Cuts                   matlab.ui.container.GridLayout
        ExportCutButton             matlab.ui.control.Button
        E_LHCPCheckBox              matlab.ui.control.CheckBox
        E_RHCPCheckBox              matlab.ui.control.CheckBox
        E_TotalCheckBox             matlab.ui.control.CheckBox
        Label_HPBW                  matlab.ui.control.Label
        HPBWButton                  matlab.ui.control.StateButton
        Tabs_Cuts                   matlab.ui.container.TabGroup
        Tab_Polar                   matlab.ui.container.Tab
        Grid_Polar                  matlab.ui.container.GridLayout
        Tab_Rect                    matlab.ui.container.Tab
        Grid_Rect                   matlab.ui.container.GridLayout
        Tab_FilledPolar             matlab.ui.container.Tab
        Grid_FilledPolar            matlab.ui.container.GridLayout
        Axes_FilledPolar            matlab.ui.control.UIAxes
        Axes_Rect                   matlab.ui.control.UIAxes
        Panel_Pattern               matlab.ui.container.Panel
        Grid_Pattern                matlab.ui.container.GridLayout
        Tabs_Pattern                matlab.ui.container.TabGroup
        Tab1_Contour                matlab.ui.container.Tab
        Grid_Contour                matlab.ui.container.GridLayout
        Axes_Contour                matlab.ui.control.UIAxes
        Tab2_Circular               matlab.ui.container.Tab
        Grid_Circular               matlab.ui.container.GridLayout
        Axes_Circular               matlab.ui.control.UIAxes
        Tab3_Spherical              matlab.ui.container.Tab
        Grid_Spherical              matlab.ui.container.GridLayout
        Axes_Spherical              matlab.ui.control.UIAxes
        Tab4_3D                     matlab.ui.container.Tab
        Grid_3D                     matlab.ui.container.GridLayout
        Axes_3D                     matlab.ui.control.UIAxes
        Panel_PlotControls          matlab.ui.container.Panel
        Grid_PlotCtrl               matlab.ui.container.GridLayout
        Input_Plot_Cstep            matlab.ui.control.Spinner
        CheckBox_Grid               matlab.ui.control.CheckBox
        CheckBox_NegAxes            matlab.ui.control.CheckBox
        ColorbarstepLabel           matlab.ui.control.Label
        Input_Plot_Cmax             matlab.ui.control.Spinner
        ColorbarmaxLabel            matlab.ui.control.Label
        Input_Plot_Cmin             matlab.ui.control.Spinner
        ColorbarminLabel            matlab.ui.control.Label
        Input_Cut_Value             matlab.ui.control.Spinner
        CutvalueLabel               matlab.ui.control.Label
        Input_RotTheta              matlab.ui.control.Spinner
        Label_RotTheta              matlab.ui.control.Label
        Input_RotPhi                matlab.ui.control.Spinner
        Label_RotPhi                matlab.ui.control.Label
        Button_Rotate               matlab.ui.control.Button
        DropDown_CutType            matlab.ui.control.DropDown
        CuttypeDropDownLabel        matlab.ui.control.Label
        Label_PlaneMode             matlab.ui.control.Label
        DropDown_PlaneMode          matlab.ui.control.DropDown
        DropDown_Component          matlab.ui.control.DropDown
        DropDown_InitOri            matlab.ui.control.DropDown
        Label_SrcTheta              matlab.ui.control.Label
        Input_SrcTheta              matlab.ui.control.Spinner
        Label_SrcPhi                matlab.ui.control.Label
        Input_SrcPhi                matlab.ui.control.Spinner
        ComponentLabel              matlab.ui.control.Label
        Tab1_Panel1                 matlab.ui.container.Panel
        T1P1_Grid                   matlab.ui.container.GridLayout
        ComputeCoverageButton       matlab.ui.control.Button
        Label_MaxInputE             matlab.ui.control.Label
        Label_MaxGain               matlab.ui.control.Label
        DominantPolLabel            matlab.ui.control.Label
        DropDown_Orientation_3      matlab.ui.control.DropDown
        DropDown_Orientation        matlab.ui.control.DropDown
        Input_Distance              matlab.ui.control.Spinner
        DistanceLabel               matlab.ui.control.Label
        DropDown_Pt                 matlab.ui.control.DropDown
        Input_Pt                    matlab.ui.control.Spinner
        TxPowerdBLabel              matlab.ui.control.Label
        Input_Rw                    matlab.ui.control.Spinner
        IncidentWaveARRw_dBLabel    matlab.ui.control.Label
        Input_Loss                  matlab.ui.control.Spinner
        LossidBLabel                matlab.ui.control.Label
        Button_ExportOutput         matlab.ui.control.Button
        Button_ExportInput          matlab.ui.control.Button
        Input_Label                 matlab.ui.control.Label
        Button_Process              matlab.ui.control.Button
        Button_Load                 matlab.ui.control.Button
        Input_PatternField          matlab.ui.control.EditField
        Label_GainCol               matlab.ui.control.Label
        DropDown_GainCol            matlab.ui.control.DropDown
        InputPatternLabel           matlab.ui.control.Label
        DropDown_Format             matlab.ui.control.DropDown
        FormatLabel                 matlab.ui.control.Label
        Tab2                        matlab.ui.container.Tab
        Tab2_Grid                   matlab.ui.container.GridLayout
        Tab2_Panel1                 matlab.ui.container.Panel
        T2P1_Grid                   matlab.ui.container.GridLayout
        DropDown_Orientation_2      matlab.ui.control.DropDown
        Input_Distance_2            matlab.ui.control.Spinner
        DistanceLabel_2             matlab.ui.control.Label
        DropDown_Pt_2               matlab.ui.control.DropDown
        Input_Pt_2                  matlab.ui.control.Spinner
        TxPowerdBLabel_2            matlab.ui.control.Label
        Input_Rw_2                  matlab.ui.control.Spinner
        IncidentWaveARRw_dBLabel_2  matlab.ui.control.Label
        Input_Loss_2                matlab.ui.control.Spinner
        LossidBLabel_2              matlab.ui.control.Label
        Button_ExportOutput_2       matlab.ui.control.Button
        Button_ExportInput_2        matlab.ui.control.Button
        Input_Label_2               matlab.ui.control.Label
        Button_Process_2            matlab.ui.control.Button
        Button_Load_2               matlab.ui.control.Button
        Input_PatternField_2        matlab.ui.control.EditField
        InputFolderLabel            matlab.ui.control.Label
        DropDown_Format_2           matlab.ui.control.DropDown
        FormatLabel_2               matlab.ui.control.Label
        Tab3                        matlab.ui.container.Tab
        Tab3_Grid                   matlab.ui.container.GridLayout
        UITable                     matlab.ui.control.Table
        Tree                        matlab.ui.container.CheckBoxTree
        Tab3_Panel1                 matlab.ui.container.Panel
        T3P1_Grid                   matlab.ui.container.GridLayout
        Button                      matlab.ui.control.Button
        Spinner_coneAng             matlab.ui.control.Spinner
        CongAngleLabel              matlab.ui.control.Label
        Spinner_conePH              matlab.ui.control.Spinner
        ConeLabel                   matlab.ui.control.Label
        Spinner_coneTH              matlab.ui.control.Spinner
        Cone0Label                  matlab.ui.control.Label
        Spinner_threshStep          matlab.ui.control.Spinner
        StepLabel                   matlab.ui.control.Label
        Spinner_threshMax           matlab.ui.control.Spinner
        ThreshMindBLabel_2          matlab.ui.control.Label
        Spinner_threshMin           matlab.ui.control.Spinner
        ThreshMindBLabel            matlab.ui.control.Label
        DropDown_covOrientation     matlab.ui.control.DropDown
        ButtonGroup_Coverage        matlab.ui.container.ButtonGroup
        Button_Spherical            matlab.ui.control.RadioButton
        Button_Conical              matlab.ui.control.RadioButton
        Button_ExportOutput_3       matlab.ui.control.Button
        Button_Process_3            matlab.ui.control.Button
        Button_Load_3               matlab.ui.control.Button
        Input_PatternField_3        matlab.ui.control.EditField
        GainPatternLabel            matlab.ui.control.Label
        UIAxes                      matlab.ui.control.UIAxes
        Tab4                        matlab.ui.container.Tab
        Tab4_Grid                   matlab.ui.container.GridLayout
        Panel_ArrayConfig           matlab.ui.container.Panel
        Grid_ArrayConfig            matlab.ui.container.GridLayout
        Button_LoadArray            matlab.ui.control.Button
        Button_ClearArray           matlab.ui.control.Button
        CheckBox_MaxHold            matlab.ui.control.CheckBox
        Table_ArraySetup            matlab.ui.control.Table
        Button_ComputeArray         matlab.ui.control.Button
        Axes_Array3D                matlab.ui.control.UIAxes
        Tab5                        matlab.ui.container.Tab
        Tab5_Grid                   matlab.ui.container.GridLayout
    end

    
    properties (Access = private)
        pax matlab.graphics.axis.PolarAxes % Polar Axes
        filePath_raw % Path to the raw antenna pattern file
        patData      % Parsed antenna pattern data for Single Pattern tab
        patData_raw  % Pristine un-mutated base geometry anchor to prevent interpolation degradation
        patData_cov  % Parsed antenna pattern data for Coverage tab
        patDataArray_cov = {} % Cell array for multiple loaded antenna patterns (Aggregate Coverage)
        covResultsList = {} % Cell array of coverage result structs
        arrayBeams     = {} % Cell array for Array Analysis phase/mag synthesis {pat, mag, phase}
        results      % Computed antenna metrics (struct)
        % Cached grid data (avoid recomputing on every plot update)
        cachedGrid   % struct: PHI, THETA, thVec, phVec, nTh, nPh, TH_rad, PH_rad, Xs, Ys, Zs, Xc, Yc, G_tot, G_rhcp, G_lhcp
        hpbwResult   % struct: cached HPBW computation result for overlay persistence
        hpbwIsUpdating = false  % Guard flag to prevent recursive HPBW overlay during OFF-state re-render
        RotMatrix = eye(3);     % Persistent SO(3) Euler Kinematics State Tracker structurally linking spins mathematically
    end
    
    methods (Access = private)
        
        function patData = parseFZ(app)
            filePath = app.filePath_raw;
            if isempty(filePath); error('parseFZ:noInput','File path required.'); end
            if ~isfile(filePath); error('parseFZ:notFound','File not found: %s',filePath); end
            [filedir,fname,fext]=fileparts(filePath);
            patData.filePath=filePath; patData.fileName=[fname fext];
            patData.header = app.parseHeader(filePath);
            
            % Modern file reading: readlines returns a string array (no fopen/fclose)
            allLines = readlines(filePath);
            
            % Find the line after 'end_<parameters>' where numeric data begins
            dataStartIdx = 0;
            for k = 1:numel(allLines)
                if contains(allLines(k), 'end_<parameters>')
                    dataStartIdx = k + 1;
                    break;
                end
            end
            if dataStartIdx == 0; error('parseFZ:noData','No data section found.'); end
            
            % Parse numeric data from remaining lines using sscanf (robust)
            dataLines = allLines(dataStartIdx:end);
            dataLines = dataLines(strlength(strtrim(dataLines)) > 0);
            dataStr = char(join(dataLines, newline));
            data = sscanf(dataStr, '%f', [6 Inf])';
            if size(data,2) ~= 6; error('parseFZ:badData','Expected 6 columns.'); end
            
            patData.theta=data(:,1); patData.phi=data(:,2);
            patData.G_theta_dB=data(:,3); patData.G_phi_dB=data(:,4);
            patData.phase_E_theta=data(:,5); patData.phase_E_phi=data(:,6);
            patData.data=data;
            patData.frequencyMHz=app.extractFreqFromPath(filedir);
            patData.isGainOnly=false;
            app.RotMatrix = eye(3);
        end
        
        function header = parseHeader(app, filePath)
            header=struct('format','free','phi_min',0,'phi_max',360,'phi_inc',1,...
                'theta_min',0,'theta_max',180,'theta_inc',1,'maximum_gain',NaN,...
                'polarization','theta_phi','magnitude','dB','phase','degrees',...
                'direction','degrees','dataType','complex','magPhase','mag_phase','pattern','gain');
            
            % Modern file reading: readlines returns string array, no fopen/fclose needed
            allLines = readlines(filePath);
            inH = false;
            for i = 1:numel(allLines)
                ln = strtrim(allLines(i));
                if contains(ln, 'begin_<parameters>'); inH = true; continue; end
                if contains(ln, 'end_<parameters>'); break; end
                if ~inH; continue; end
                tok = split(ln);
                if isempty(tok) || tok(1) == ""; continue; end
                k = tok(1);
                switch lower(k)
                    case 'format';       if numel(tok)>=2; header.format=char(tok(2)); end
                    case 'phi_min';      if numel(tok)>=2; header.phi_min=str2double(tok(2)); end
                    case 'phi_max';      if numel(tok)>=2; header.phi_max=str2double(tok(2)); end
                    case 'phi_inc';      if numel(tok)>=2; header.phi_inc=str2double(tok(2)); end
                    case 'theta_min';    if numel(tok)>=2; header.theta_min=str2double(tok(2)); end
                    case 'theta_max';    if numel(tok)>=2; header.theta_max=str2double(tok(2)); end
                    case 'theta_inc';    if numel(tok)>=2; header.theta_inc=str2double(tok(2)); end
                    case 'maximum_gain'; if numel(tok)>=2; header.maximum_gain=str2double(tok(2)); end
                    case 'polarization'; if numel(tok)>=2; header.polarization=char(tok(2)); end
                    case 'magnitude';    if numel(tok)>=2; header.magnitude=char(tok(2)); end
                    case 'phase';        if numel(tok)>=2; header.phase=char(tok(2)); end
                    case 'direction';    if numel(tok)>=2; header.direction=char(tok(2)); end
                    case 'pattern';      if numel(tok)>=2; header.pattern=char(tok(2)); end
                    case 'complex';      header.dataType='complex';
                    case 'real';         header.dataType='real';
                    case 'mag_phase';    header.magPhase='mag_phase';
                end
            end
        end

        function freqMHz = extractFreqFromPath(app, dirPath)
            freqMHz=NaN; parts=strsplit(dirPath,{filesep,'/'});
            for k=numel(parts):-1:1
                m=regexp(parts{k},'([\d.]+)\s*MHz','tokens','ignorecase');
                if ~isempty(m); freqMHz=str2double(m{1}{1}); return; end
                m=regexp(parts{k},'([\d.]+)\s*GHz','tokens','ignorecase');
                if ~isempty(m); freqMHz=str2double(m{1}{1})*1000; return; end
            end
        end
        
        function results = computeAntennaMetrics(app, patData, params)
            if nargin < 2; params = struct(); end
            if ~isfield(params,'Rw_dB');    params.Rw_dB=6;     end
            if ~isfield(params,'Ptx_dBW');  params.Ptx_dBW=0;   end
            if ~isfield(params,'dist_m');   params.dist_m=1;     end
            if ~isfield(params,'Loss_dB');  params.Loss_dB=0;    end
            dTau=90;
            Rw_lin_mag=10^(abs(params.Rw_dB)/20);
            N=numel(patData.G_theta_dB);

            % ── Handle gain-only data (CSV/TXT with no polarization info) ──
            if isfield(patData,'isGainOnly') && patData.isGainOnly
                G_total_dB = patData.G_theta_dB;  % gain stored in G_theta_dB
                results=struct();
                results.theta=patData.theta; results.phi=patData.phi;
                results.G_theta_dB=G_total_dB; results.G_phi_dB=NaN(N,1);
                results.phase_E_theta=zeros(N,1); results.phase_E_phi=zeros(N,1);
                results.E_theta=NaN(N,1); results.E_phi=NaN(N,1);
                results.E_RCP=NaN(N,1); results.E_LCP=NaN(N,1);
                results.G_total_dB=G_total_dB; results.AR_lin=NaN(N,1); results.AR_dB=NaN(N,1);
                results.E_RHCP_dB=NaN(N,1); results.E_LHCP_dB=NaN(N,1);
                results.phase_ERCP=NaN(N,1); results.phase_ELCP=NaN(N,1);
                results.PLF_dB=zeros(N,1); results.G_polCorrected_dB=G_total_dB-params.Loss_dB;
                EIRP_dBW=params.Ptx_dBW+G_total_dB-params.Loss_dB;
                R=params.dist_m;
                results.E_field_dBVm=EIRP_dBW+10*log10(30)-20*log10(R);
                results.EIRP_dBW=EIRP_dBW;
                results.PFD_dBWm2=EIRP_dBW-10*log10(4*pi*R^2);
                results.params=params; results.dTau=dTau;
                results.Rw_lin_mag=Rw_lin_mag; results.Rw_signed=Rw_lin_mag;
                results.dominantPol='N/A (Gain Only)'; results.header=patData.header;
                results.frequencyMHz=patData.frequencyMHz;
                results.filePath=patData.filePath; results.fileName=patData.fileName;
                results.isGainOnly=true;
                results.table=table(patData.theta,patData.phi,...
                    G_total_dB, ...
                    NaN(N,1),NaN(N,1),NaN(N,1),NaN(N,1),NaN(N,1),...
                    zeros(N,1),G_total_dB-params.Loss_dB,...
                    results.E_field_dBVm,EIRP_dBW,results.PFD_dBWm2,...
                    'VariableNames',{'Theta','Phi',...
                    'G_Total_dB','AR_dB',...
                    'E_RHCP_dB','E_LHCP_dB','Phase_ERCP','Phase_ELCP',...
                    'PLF_dB','G_PolCorrected_dB',...
                    'E_Field_dBVm','EIRP_dBW','PFD_dBWm2'});
                return;
            end

            G_theta_dB=patData.G_theta_dB; G_phi_dB=patData.G_phi_dB;
            phase_Etheta=patData.phase_E_theta; phase_Ephi=patData.phase_E_phi;
            G_theta_lin=10.^(G_theta_dB/10); G_phi_lin=10.^(G_phi_dB/10);
            E_theta=sqrt(G_theta_lin).*exp(1j*deg2rad(phase_Etheta));
            E_phi=sqrt(G_phi_lin).*exp(1j*deg2rad(phase_Ephi));
            E_RCP=(E_theta+1j*E_phi)/sqrt(2); 
            E_LCP=(E_theta-1j*E_phi)/sqrt(2);
            % Direct addition (mathematic equivalent to abs(E_theta)^2 + abs(E_phi)^2)
            G_total_lin=G_theta_lin + G_phi_lin;
            % Guard against zero-power samples producing -Inf in dB (clamp at numerical floor)
            G_total_dB=10*log10(max(G_total_lin, 1e-30));
            G_RCP_lin=abs(E_RCP).^2; G_LCP_lin=abs(E_LCP).^2;
            E_RHCP_dB=10*log10(max(G_RCP_lin, 1e-30)); E_LHCP_dB=10*log10(max(G_LCP_lin, 1e-30));
            phase_ERCP=rad2deg(angle(E_RCP)); phase_ELCP=rad2deg(angle(E_LCP));
            absRCP=abs(E_RCP); absLCP=abs(E_LCP);
            
            % Fully vectorized Axial Ratio computation avoids building 6+ full-size memory masks
            r = absRCP ./ max(absLCP, eps(0)); 
            AR_lin = ones(N,1);
            
            rhcp_mask = r > 1;
            AR_lin(rhcp_mask) = (r(rhcp_mask) + 1) ./ max(r(rhcp_mask) - 1, eps(0));
            
            lhcp_mask = r < 1;
            AR_lin(lhcp_mask) = -(r(lhcp_mask) + 1) ./ max(1 - r(lhcp_mask), eps(0));
            
            % Pure edge cases
            AR_lin(absLCP == 0 & absRCP > 0) = 1;     % Pure RCP (0 dB)
            AR_lin(absRCP == 0 & absLCP > 0) = -1;    % Pure LCP (0 dB)
            AR_lin(absRCP == absLCP) = sqrt(10)/1e13; % Perfectly Linear mapped to Sentinel dB
            
            AR_dB=sign(AR_lin).*20.*log10(abs(AR_lin));
            SENTINEL=-250; validMask=(G_theta_dB>SENTINEL)|(G_phi_dB>SENTINEL);
            if any(validMask); meanRCP=mean(G_RCP_lin(validMask)); meanLCP=mean(G_LCP_lin(validMask));
            else; meanRCP=0; meanLCP=0; end
            if meanRCP>=meanLCP; Rw_signed=Rw_lin_mag; dominantPol='RHCP';
            else; Rw_signed=-Rw_lin_mag; dominantPol='LHCP'; end
            Ra=AR_lin; Rw=Rw_signed;
            PLF_lin=0.5+(4*Ra.*Rw+(Ra.^2-1).*(Rw^2-1).*cosd(2*dTau))./(2*(Ra.^2+1).*(Rw^2+1));
            PLF_lin=max(0,min(1,PLF_lin));
            PLF_dB=10*log10(max(PLF_lin,1e-30));
            G_polCorrected_dB=G_total_dB+PLF_dB-params.Loss_dB;
            EIRP_dBW=params.Ptx_dBW+G_total_dB-params.Loss_dB;
            R=params.dist_m;
            E_field_dBVm=EIRP_dBW+10*log10(30)-20*log10(R);
            PFD_dBWm2=EIRP_dBW-10*log10(4*pi*R^2);
            results=struct();
            results.theta=patData.theta; results.phi=patData.phi;
            results.G_theta_dB=G_theta_dB; results.G_phi_dB=G_phi_dB;
            results.phase_E_theta=phase_Etheta; results.phase_E_phi=phase_Ephi;
            results.E_theta=E_theta; results.E_phi=E_phi;
            results.E_RCP=E_RCP; results.E_LCP=E_LCP;
            results.G_total_dB=G_total_dB; results.AR_lin=AR_lin; results.AR_dB=AR_dB;
            results.E_RHCP_dB=E_RHCP_dB; results.E_LHCP_dB=E_LHCP_dB;
            results.phase_ERCP=phase_ERCP; results.phase_ELCP=phase_ELCP;
            results.PLF_dB=PLF_dB; results.G_polCorrected_dB=G_polCorrected_dB;
            results.E_field_dBVm=E_field_dBVm; results.EIRP_dBW=EIRP_dBW;
            results.PFD_dBWm2=PFD_dBWm2;
            results.params=params; results.dTau=dTau;
            results.Rw_lin_mag=Rw_lin_mag; results.Rw_signed=Rw_signed;
            results.dominantPol=dominantPol; results.header=patData.header;
            results.frequencyMHz=patData.frequencyMHz;
            results.filePath=patData.filePath; results.fileName=patData.fileName;
            results.isGainOnly=false;
            results.table=table(patData.theta,patData.phi,...
                G_total_dB,AR_dB,...
                E_RHCP_dB,E_LHCP_dB,phase_ERCP,phase_ELCP,...
                PLF_dB,G_polCorrected_dB,...
                E_field_dBVm,EIRP_dBW,PFD_dBWm2,...
                'VariableNames',{'Theta','Phi',...
                'G_Total_dB','AR_dB',...
                'E_RHCP_dB','E_LHCP_dB','Phase_ERCP','Phase_ELCP',...
                'PLF_dB','G_PolCorrected_dB',...
                'E_Field_dBVm','EIRP_dBW','PFD_dBWm2'});
        end

        function result = computeCoverage(app)
            % computeCoverage — compute coverage % vs threshold sweep
            
            pArr = app.patDataArray_cov;
            if isempty(pArr)
                % Fallback parameter fetch
                if isempty(app.patData_cov)
                    error('No antenna patterns loaded for coverage calculation.');
                 else
                     pArr = {app.patData_cov};
                 end
            end
            
            % Compute base parameters / grid matching off the first element
            fzD = pArr{1};
            
            % Reuse cached metrics if the same single file was already processed in Tab 1
            if numel(pArr) == 1 && ~isempty(app.results) && strcmp(app.results.filePath, fzD.filePath)
                met = app.results;
            else
                params = struct('Rw_dB',6,'Ptx_dBW',0,'dist_m',1,'Loss_dB',0);
                met = app.computeAntennaMetrics(fzD, params);
            end
            
            % Initialize the envelope array
            G_dB = met.G_total_dB;
            
            % Aggregate across all loaded patterns (Best Server Maximum Envelope)
            for k = 2:numel(pArr)
                params = struct('Rw_dB',6,'Ptx_dBW',0,'dist_m',1,'Loss_dB',0);
                met_k = app.computeAntennaMetrics(pArr{k}, params);
                % Validate identical grid dimensions
                if numel(met_k.G_total_dB) ~= numel(G_dB)
                    error('Pattern %d (%s) grid size mismatch. All loaded beams must have identical Theta/Phi meshing for Aggregate CDF.', k, pArr{k}.fileName);
                end
                
                % Take the element-wise maximum
                G_dB = max(G_dB, met_k.G_total_dB);
            end

            thMin  = app.Spinner_threshMin.Value;
            thMax  = app.Spinner_threshMax.Value;
            thStep = app.Spinner_threshStep.Value;
            thresholds = thMin:thStep:thMax;

            theta = fzD.theta;
            phi   = fzD.phi;

            % Determine grid increments from header
            dTheta = deg2rad(fzD.header.theta_inc);
            dPhi   = deg2rad(fzD.header.phi_inc);

            % ── Analytically Exact Solid-angle Patch Weights ──
            % Instead of the approximation  dΩ ≈ sin(θ)·Δθ·Δφ  we integrate
            % exactly over each cell:  dΩ = Δφ·∫sin(θ)dθ  from θ−Δθ/2 to θ+Δθ/2
            % Using cos(a−b)−cos(a+b) = 2·sin(a)·sin(b):
            exactW = dPhi .* 2 .* sind(theta) .* sin(dTheta/2);
            
            % 1. Fix poles (θ=0° or θ=180°): cap extends only outward by Δθ/2
            poleMask = (theta == 0) | (theta == 180);
            exactW(poleMask) = dPhi .* (1 - cos(dTheta/2));
            
            % 2. Fix φ overlap: if data spans 0°→360°, both endpoints map to
            %    the same physical meridian — halve their weight to avoid 2× count
            overlapPhi = (phi == 0) | (phi == 360);
            exactW(overlapPhi) = exactW(overlapPhi) / 2;

            sinW = exactW;

            % Determine coverage type
            isCone = app.Button_Conical.Value;

            if isCone
                th0  = app.Spinner_coneTH.Value;
                ph0  = app.Spinner_conePH.Value;
                alpha = app.Spinner_coneAng.Value;

                % Great-circle angular distance from cone centre
                % Spherical Law of Cosines: cos(a)=cos(b)cos(c)+sin(b)sin(c)cos(A)
                dotProd = cosd(theta).*cosd(th0) + sind(theta).*sind(th0).*cosd(phi - ph0);
                % Clamp to [-1, 1] — IEEE-754 rounding can yield |val|>1 → NaN in acosd
                dotProd = max(min(dotProd, 1), -1);
                angDist = acosd(dotProd);
                mask = (angDist < alpha);

                totalSA = sum(sinW(mask));
                covType = 'Conical';
                
                oriVal = app.DropDown_covOrientation.Value;
                switch oriVal
                    case '2'; oriStr = ' (+X)';
                    case '3'; oriStr = ' (-X)';
                    case '4'; oriStr = ' (+Y)';
                    case '5'; oriStr = ' (-Y)';
                    case '6'; oriStr = ' (+Z)';
                    case '7'; oriStr = ' (-Z)';
                    otherwise; oriStr = '';
                end
                if isempty(oriStr)
                    covLabel = sprintf('Conical_%.0f° (θ=%.0f°, φ=%.0f°)', alpha, th0, ph0);
                else
                    covLabel = sprintf('Conical_%.0f°%s', alpha, oriStr);
                end
                covParams = struct('alpha',alpha,'theta0',th0,'phi0',ph0);
            else
                mask = true(size(theta));
                totalSA = sum(sinW);
                covType = 'Spherical';
                covLabel = 'Spherical (Full)';
                covParams = struct();
            end

            % ── Coverage % for each threshold ──
            % Extract only the points inside the coverage region (pre-filter)
            maskedSinW = sinW(mask);   % solid-angle weights within region
            maskedG    = G_dB(mask);   % gain values within region
            
            % Direct mathematical definition:
            %   Coverage(T) = [ Σ ΔΩᵢ  for all i where Gᵢ > T ] / totalSA × 100%
            if totalSA > 0
                coverage_pct = arrayfun(@(T) 100 * sum(maskedSinW(maskedG > T)) / totalSA, thresholds);
            else
                coverage_pct = zeros(size(thresholds));
            end

            result.type         = covType;
            result.params       = covParams;
            result.label        = covLabel;
            result.thresholds   = thresholds(:);
            result.coverage_pct = coverage_pct(:);
            result.tableData    = table(thresholds(:), coverage_pct(:), 'VariableNames', {'Threshold_dB', ['Coverage_pct_' strrep(covLabel,' ','_')]});
        end

        % ════════════════════════════════════════════════════════════════
        %  UNIFIED PARSER DISPATCHER — routes by file extension
        % ════════════════════════════════════════════════════════════════
        function patData = parsePatternFile(app)
            [~,~,ext] = fileparts(app.filePath_raw);
            switch lower(ext)
                case '.fz';            patData = app.parseFZ();
                case '.uan';           patData = app.parseFZ();       % UAN ≡ FZ format
                case '.cut';           patData = app.parseGRASP_cut();
                case '.out';           patData = app.parseGRASP_out();
                case '.ffs';           patData = app.parseFFS();
                case '.ffd';           patData = app.parseFFD();
                case '.ffe';           patData = app.parseFFE();
                case {'.csv','.txt'};  patData = app.parseGainCSV();
                otherwise;             error('parsePatternFile:unsupported','Unsupported format: %s', ext);
            end
            
            % Execute strict mathematical coordinate filtration:
            % Normalizes negative Phis back cleanly into [0, 360) and algorithmically 
            % deduplicates exact boundaries to conserve isRegularGrid topology algorithms.
            patData = app.cleanseCoordinateArrays(patData);
        end

        % ════════════════════════════════════════════════════════════════
        %  HELPER: Coordinate Normalization & Seam Fusion
        % ════════════════════════════════════════════════════════════════
        function p = cleanseCoordinateArrays(~, p)
            % 1. Align phi to mathematical strictly positive bounds [0, 360) safely 
            %    (-180 becomes 180, 360 becomes 0, etc.)
            p.phi = mod(p.phi, 360);
            
            % 2. Eliminate mathematically overlapping edges caused by seam normalization
            %    (If -180 overlaps with 180, mapping both into 180 creates duplicates
            %     that destroy unique(phi) regular grid heuristics)
            [~, uIdx] = unique([p.theta, p.phi], 'rows');
            
            if numel(uIdx) < numel(p.theta)
                % Only rebuild slices if overlaps genuinely exist to save mem footprint
                p.theta         = p.theta(uIdx);
                p.phi           = p.phi(uIdx);
                p.G_theta_dB    = p.G_theta_dB(uIdx);
                p.G_phi_dB      = p.G_phi_dB(uIdx);
                if isfield(p, 'phase_E_theta'); p.phase_E_theta = p.phase_E_theta(uIdx); end
                if isfield(p, 'phase_E_phi');   p.phase_E_phi   = p.phase_E_phi(uIdx); end
                if isfield(p, 'data') && size(p.data, 1) >= numel(p.theta)
                    p.data = p.data(uIdx, :);
                end
            end
            
            % 3. Round to eliminate terminal IEEE floating point geometry noise (e.g. 89.999)
            p.theta = round(p.theta, 2);
            p.phi   = round(p.phi, 2);
            
            % 4. Duplicate the Phi=0 seam directly to Phi=360 to prevent visual truncation in mapping geometries
            phU = unique(p.phi);
            if numel(phU) > 1
                dPh = median(diff(phU));
                % If max(phi) plus one step lands exactly on or past 360, it represents a full continuous sphere
                if (360 - max(phU)) <= 1.5 * dPh && ~ismember(360, p.phi)
                    idx0 = find(p.phi == 0);
                    if ~isempty(idx0)
                        p.theta      = [p.theta;      p.theta(idx0)];
                        p.phi        = [p.phi;        repmat(360, numel(idx0), 1)];
                        p.G_theta_dB = [p.G_theta_dB; p.G_theta_dB(idx0)];
                        p.G_phi_dB   = [p.G_phi_dB;   p.G_phi_dB(idx0)];
                        if isfield(p, 'phase_E_theta'); p.phase_E_theta = [p.phase_E_theta; p.phase_E_theta(idx0)]; end
                        if isfield(p, 'phase_E_phi');   p.phase_E_phi   = [p.phase_E_phi;   p.phase_E_phi(idx0)]; end
                        if isfield(p, 'data') && size(p.data, 1) >= numel(idx0)
                            newData = p.data(idx0, :);
                            if size(newData, 2) >= 2; newData(:, 2) = 360; end % Sync phi tracking inside raw array mapping
                            p.data = [p.data; newData];
                        end
                        
                        % Re-sort sequentially to maintain perfectly chronological linear blocks for Fast-Path Rendering
                        [~, sortIdx] = sortrows([p.phi, p.theta], [1, 2]); % Sort strictly by Phi-Major natively
                        p.theta      = p.theta(sortIdx);
                        p.phi        = p.phi(sortIdx);
                        p.G_theta_dB = p.G_theta_dB(sortIdx);
                        p.G_phi_dB   = p.G_phi_dB(sortIdx);
                        if isfield(p, 'phase_E_theta'); p.phase_E_theta = p.phase_E_theta(sortIdx); end
                        if isfield(p, 'phase_E_phi');   p.phase_E_phi   = p.phase_E_phi(sortIdx); end
                        if isfield(p, 'data') && size(p.data, 1) == numel(sortIdx); p.data = p.data(sortIdx, :); end
                    end
                end
            end
        end

        % ════════════════════════════════════════════════════════════════
        %  HELPER: Complex Re/Im → Magnitude(dB) + Phase(°)
        % ════════════════════════════════════════════════════════════════
        function [Gth_dB, Gph_dB, phTh, phPh] = complexToMagPhase(~, rTh, iTh, rPh, iPh)
            Eth = complex(rTh, iTh);
            Eph = complex(rPh, iPh);
            Gth_dB = 20*log10(max(abs(Eth), 1e-30));
            Gph_dB = 20*log10(max(abs(Eph), 1e-30));
            phTh = rad2deg(angle(Eth));
            phPh = rad2deg(angle(Eph));
        end

        % ════════════════════════════════════════════════════════════════
        %  HELPER: Build header struct from theta/phi data vectors
        % ════════════════════════════════════════════════════════════════
        function header = buildHeaderFromData(~, theta, phi, freqMHz)
            thU = unique(theta); phU = unique(phi);
            header = struct();
            header.format     = 'free';
            header.theta_min  = min(thU);
            header.theta_max  = max(thU);
            header.theta_inc  = median(diff(thU));
            header.phi_min    = min(phU);
            header.phi_max    = max(phU);
            header.phi_inc    = median(diff(phU));
            % Compute maximum gain from total E-field magnitude
            header.maximum_gain = NaN;  % to be updated by caller if needed
            header.polarization = 'theta_phi';
            header.magnitude  = 'dB';
            header.phase      = 'degrees';
            header.direction  = 'degrees';
            header.dataType   = 'complex';
            header.magPhase   = 'mag_phase';
            header.pattern    = 'gain';
            if nargin >= 4 && ~isnan(freqMHz)
                header.frequencyMHz = freqMHz;
            end
        end

        % ════════════════════════════════════════════════════════════════
        %  PARSER: TICRA GRASP .out (grid format)
        % ════════════════════════════════════════════════════════════════
        function patData = parseGRASP_out(app)
            filePath = app.filePath_raw;
            if ~isfile(filePath); error('parseGRASP_out:notFound','File not found: %s',filePath); end
            [~,fname,fext] = fileparts(filePath);
            patData.filePath = filePath;
            patData.fileName = [fname fext];

            % Modern file reading: readlines returns string array (no fopen/fclose)
            allLines = readlines(filePath);

            % Line 1: descriptive header — extract frequency if present
            hdrLine = char(allLines(1));
            freqMHz = NaN;
            mGHz = regexp(hdrLine, '([\d.]+)\s*GHz', 'tokens', 'ignorecase');
            if ~isempty(mGHz); freqMHz = str2double(mGHz{1}{1}) * 1000; end
            mMHz = regexp(hdrLine, '([\d.]+)\s*MHz', 'tokens', 'ignorecase');
            if ~isempty(mMHz); freqMHz = str2double(mMHz{1}{1}); end

            % Skip 2 header lines, parse numeric data from line 3 onward
            dataLines = allLines(3:end);
            dataLines = dataLines(strlength(strtrim(dataLines)) > 0);
            dataStr = char(join(dataLines, newline));
            data = sscanf(dataStr, '%f', [6 Inf])';
            if isempty(data) || size(data,2) ~= 6
                error('parseGRASP_out:badData', 'Expected 6 columns (THETA PHI Re1 Im1 Re2 Im2).');
            end

            theta = data(:,1);
            phi   = data(:,2);
            [Gth_dB, Gph_dB, phTh, phPh] = app.complexToMagPhase(data(:,3), data(:,4), data(:,5), data(:,6));

            patData.theta         = theta;
            patData.phi           = phi;
            patData.G_theta_dB    = Gth_dB;
            patData.G_phi_dB      = Gph_dB;
            patData.phase_E_theta = phTh;
            patData.phase_E_phi   = phPh;
            patData.data          = [theta, phi, Gth_dB, Gph_dB, phTh, phPh];
            patData.frequencyMHz  = freqMHz;
            patData.isGainOnly    = false;
            patData.header        = app.buildHeaderFromData(theta, phi, freqMHz);
            G_total_lin = 10.^(Gth_dB/10) + 10.^(Gph_dB/10);
            patData.header.maximum_gain = 10*log10(max(G_total_lin));
        end

        % ════════════════════════════════════════════════════════════════
        %  PARSER: CST Studio .ffs (Far-Field Source)
        % ════════════════════════════════════════════════════════════════
        function patData = parseFFS(app)
            filePath = app.filePath_raw;
            if ~isfile(filePath); error('parseFFS:notFound','File not found: %s',filePath); end
            [~,fname,fext] = fileparts(filePath);
            patData.filePath = filePath;
            patData.fileName = [fname fext];

            % Modern file reading: readlines returns string array (no fopen/fclose)
            allLines = readlines(filePath);

            % Find first line with >= 6 numeric columns (skip headers)
            dataStartIdx = 0;
            for li = 1:numel(allLines)
                vals = str2num(char(allLines(li))); %#ok<ST2NM>
                if numel(vals) >= 6
                    dataStartIdx = li;
                    break;
                end
            end
            if dataStartIdx == 0
                error('parseFFS:noData', 'No numeric data found in CST .ffs file.');
            end

            % Parse numeric data from dataStart onward using sscanf (robust)
            dataLines = allLines(dataStartIdx:end);
            dataLines = dataLines(strlength(strtrim(dataLines)) > 0);
            dataStr = char(join(dataLines, newline));
            data = sscanf(dataStr, '%f', [6 Inf])';

            % CST .ffs column order: Phi, Theta, Re(Eth), Im(Eth), Re(Eph), Im(Eph)
            phi   = data(:,1);
            theta = data(:,2);
            [Gth_dB, Gph_dB, phTh, phPh] = app.complexToMagPhase(data(:,3), data(:,4), data(:,5), data(:,6));

            patData.theta         = theta;
            patData.phi           = phi;
            patData.G_theta_dB    = Gth_dB;
            patData.G_phi_dB      = Gph_dB;
            patData.phase_E_theta = phTh;
            patData.phase_E_phi   = phPh;
            patData.data          = [theta, phi, Gth_dB, Gph_dB, phTh, phPh];
            patData.frequencyMHz  = NaN;
            patData.isGainOnly    = false;
            patData.header        = app.buildHeaderFromData(theta, phi, NaN);
            G_total_lin = 10.^(Gth_dB/10) + 10.^(Gph_dB/10);
            patData.header.maximum_gain = 10*log10(max(G_total_lin));
        end

        % ════════════════════════════════════════════════════════════════
        %  PARSER: Ansys HFSS .ffd (Far-Field Data)
        % ════════════════════════════════════════════════════════════════
        function patData = parseFFD(app)
            filePath = app.filePath_raw;
            if ~isfile(filePath); error('parseFFD:notFound','File not found: %s',filePath); end
            [~,fname,fext] = fileparts(filePath);
            patData.filePath = filePath;
            patData.fileName = [fname fext];

            allLines = readlines(filePath);

            % Line 1: theta_start theta_stop num_theta_pts
            thLine = str2num(char(allLines(1))); %#ok<ST2NM>
            th_start = thLine(1); th_stop = thLine(2); nTh = thLine(3);

            % Line 2: phi_start phi_stop num_phi_pts
            phLine = str2num(char(allLines(2))); %#ok<ST2NM>
            ph_start = phLine(1); ph_stop = phLine(2); nPh = phLine(3);

            % Identify Multi-Frequency Blocks iteratively via "Frequency " tag
            freqIdxList = find(startsWith(allLines, "Frequency ", 'IgnoreCase', true));
            if isempty(freqIdxList)
                error('parseFFD:badFormat','No frequency definition block found.');
            end
            
            selFreqIdx = 1;
            if numel(freqIdxList) > 1
                freqLabels = strip(allLines(freqIdxList));
                [sel, isOk] = listdlg('ListString', freqLabels, 'SelectionMode', 'single', ...
                                      'Name', 'Select Antenna Frequency', 'PromptString', 'HFSS FFD contains multi-frequency geometry blocks. Select one to load:', ...
                                      'ListSize', [300, 150]);
                if isOk
                    selFreqIdx = sel;
                else
                    selFreqIdx = 1; % Default back locally if users X out
                end
            end
            
            targetFreqLineIdx = freqIdxList(selFreqIdx);
            
            % Constrain read block strictly up to next frequency row
            if selFreqIdx < numel(freqIdxList)
                endDataIdx = freqIdxList(selFreqIdx + 1) - 1;
            else
                endDataIdx = numel(allLines);
            end

            freqTok = regexp(char(allLines(targetFreqLineIdx)), '[\d.eE+-]+', 'match');
            freqMHz = str2double(freqTok{1}) / 1e6;

            % Build explicit native angle grid mapping from header constraints
            thVec = linspace(th_start, th_stop, nTh);
            phVec = linspace(ph_start, ph_stop, nPh);

            % Parse strictly the targeted numeric block iteratively
            dataLines = allLines(targetFreqLineIdx+1 : endDataIdx);
            dataLines = dataLines(strlength(strtrim(dataLines)) > 0);
            dataStr = char(join(dataLines, newline));
            data = sscanf(dataStr, '%f', [4 Inf])';
            
            expectedRows = nTh * nPh;
            if size(data,1) < expectedRows
                error('parseFFD:badData', 'Expected %d data rows for frequency %.2f MHz, found %d.', expectedRows, freqMHz, size(data,1));
            end
            data = data(1:expectedRows, :);

            [PH, TH] = ndgrid(phVec, thVec);
            theta = TH(:);
            phi   = PH(:);

            [Gth_dB, Gph_dB, phTh, phPh] = app.complexToMagPhase(data(:,1), data(:,2), data(:,3), data(:,4));

            patData.theta         = theta;
            patData.phi           = phi;
            patData.G_theta_dB    = Gth_dB;
            patData.G_phi_dB      = Gph_dB;
            patData.phase_E_theta = phTh;
            patData.phase_E_phi   = phPh;
            patData.data          = [theta, phi, Gth_dB, Gph_dB, phTh, phPh];
            patData.frequencyMHz  = freqMHz;
            patData.isGainOnly    = false;
            patData.header        = app.buildHeaderFromData(theta, phi, freqMHz);
            
            G_total_lin = 10.^(Gth_dB/10) + 10.^(Gph_dB/10);
            patData.header.maximum_gain = 10*log10(max(G_total_lin));
        end

        % ════════════════════════════════════════════════════════════════
        %  PARSER: Altair FEKO .ffe (Far-Field Export)
        % ════════════════════════════════════════════════════════════════
        function patData = parseFFE(app)
            filePath = app.filePath_raw;
            if ~isfile(filePath); error('parseFFE:notFound','File not found: %s',filePath); end
            [~,fname,fext] = fileparts(filePath);
            patData.filePath = filePath;
            patData.fileName = [fname fext];

            % Modern file reading: readlines (no fopen/fclose)
            allLines = readlines(filePath);

            % Parse header lines for frequency, find data start
            freqMHz = NaN;
            dataStartIdx = 0;
            for li = 1:numel(allLines)
                ln = strtrim(allLines(li));
                if startsWith(ln, '#Frequency:')
                    tok = regexp(char(ln), '[\d.eE+-]+', 'match');
                    if ~isempty(tok); freqMHz = str2double(tok{1}) / 1e6; end
                end
                % First non-comment, non-empty line = data start
                if strlength(ln) > 0 && ~startsWith(ln, '#') && ~startsWith(ln, '**') && ~startsWith(ln, '"')
                    dataStartIdx = li;
                    break;
                end
            end
            if dataStartIdx == 0
                error('parseFFE:noData','No numeric data found in FEKO .ffe file.');
            end

            % Parse numeric data from data start onward using sscanf (robust)
            dataLines = allLines(dataStartIdx:end);
            dataLines = dataLines(strlength(strtrim(dataLines)) > 0);
            dataStr = char(join(dataLines, newline));
            data = sscanf(dataStr, '%f', [9 Inf])';
            if isempty(data) || size(data,2) < 6
                error('parseFFE:badData', 'Expected at least 6 columns in FEKO .ffe file.');
            end

            theta = data(:,1);
            phi   = data(:,2);
            [Gth_dB, Gph_dB, phTh, phPh] = app.complexToMagPhase(data(:,3), data(:,4), data(:,5), data(:,6));

            patData.theta         = theta;
            patData.phi           = phi;
            patData.G_theta_dB    = Gth_dB;
            patData.G_phi_dB      = Gph_dB;
            patData.phase_E_theta = phTh;
            patData.phase_E_phi   = phPh;
            patData.data          = [theta, phi, Gth_dB, Gph_dB, phTh, phPh];
            patData.frequencyMHz  = freqMHz;
            patData.isGainOnly    = false;
            patData.header        = app.buildHeaderFromData(theta, phi, freqMHz);
            G_total_lin = 10.^(Gth_dB/10) + 10.^(Gph_dB/10);
            patData.header.maximum_gain = 10*log10(max(G_total_lin));
        end

        % ════════════════════════════════════════════════════════════════
        %  PARSER: Gain-only CSV/TXT
        % ════════════════════════════════════════════════════════════════
        function patData = parseGainCSV(app)
            filePath = app.filePath_raw;
            if ~isfile(filePath); error('parseGainCSV:notFound','File not found: %s',filePath); end
            [~,fname,fext] = fileparts(filePath);
            patData.filePath = filePath;
            patData.fileName = [fname fext];

            % Modern file reading: readlines returns string array (no fopen/fclose)
            allLines = readlines(filePath);

            % Skip header lines (starting with #, %, or non-numeric text)
            dataStartIdx = 0;
            for li = 1:numel(allLines)
                ln = strtrim(allLines(li));
                if strlength(ln) == 0; continue; end
                if startsWith(ln, '#') || startsWith(ln, '%'); continue; end
                vals = str2num(char(ln)); %#ok<ST2NM>
                if numel(vals) >= 3
                    dataStartIdx = li;
                    break;
                end
            end
            if dataStartIdx == 0
                error('parseGainCSV:noData', 'No numeric data found in CSV/TXT file.');
            end

            % Determine number of columns from first data line
            firstVals = str2num(char(allLines(dataStartIdx))); %#ok<ST2NM>
            nCols = numel(firstVals);
            % Parse numeric data from dataStart onward using sscanf (robust)
            dataLines = allLines(dataStartIdx:end);
            dataLines = dataLines(strlength(strtrim(dataLines)) > 0);
            % Replace commas with spaces so sscanf handles both CSV and whitespace-delimited
            dataStr = char(join(dataLines, newline));
            dataStr = strrep(dataStr, ',', ' ');
            data = sscanf(dataStr, '%f', [nCols Inf])';

            col1 = data(:,1);
            col2 = data(:,2);

            % Auto-detect Theta/Phi logic based on typical spherical boundaries
            % Theta is strictly <= 180 (usually), Phi is <= 360 (usually).
            if max(col1) > 185 && max(col2) <= 185
                theta = col2;
                phi   = col1;
            else
                theta = col1;
                phi   = col2;
            end

            gainCol = 3;

            patData.theta         = theta;
            patData.phi           = phi;
            patData.G_theta_dB    = data(:, gainCol);
            patData.G_phi_dB      = NaN(size(theta));
            patData.phase_E_theta = zeros(size(theta));
            patData.phase_E_phi   = zeros(size(theta));
            patData.data          = data;
            patData.frequencyMHz  = NaN;
            patData.isGainOnly    = true;
            patData.numDataCols   = nCols;
            patData.gainColIndex  = gainCol;
            patData.header        = app.buildHeaderFromData(theta, phi, NaN);
            patData.header.maximum_gain = max(data(:, gainCol));
        end

        % ════════════════════════════════════════════════════════════════
        %  PARSER: TICRA GRASP .cut (placeholder — not yet implemented)
        % ════════════════════════════════════════════════════════════════
        function patData = parseGRASP_cut(app)  %#ok<STOUT>
            error('parseGRASP_cut:notImplemented', ...
                'GRASP .cut format parser is not yet implemented. Please provide a sample file.');
        end
    end
    
    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.pax = polaraxes(app.Grid_Polar);
            cla(app.pax,"reset");
            reset(app.pax);
            app.pax.ThetaZeroLocation='top';
            app.pax.ThetaDir = 'clockwise';
            
            app.Table_DataIn.RowName = 'numbered';
            app.Table_DataOut.RowName = 'numbered';
        end

        % Callback function
        function Button_LoadPushed(app, event)
            % loadButtonPushed
        end

        % Button pushed function: Button_Load
        function loadButtonPushed(app, event)
            [fname, fpath] = uigetfile({
                '*.fz;*.uan',       'Remcom XGTD (*.fz, *.uan)';
                '*.cut;*.out',      'TICRA GRASP (*.cut, *.out)';
                '*.ffs',            'CST Studio (*.ffs)';
                '*.ffd',            'Ansys HFSS (*.ffd)';
                '*.ffe',            'Altair FEKO (*.ffe)';
                '*.csv;*.txt;*.dat','Gain CSV/TXT (*.csv, *.txt)';
                '*.*',              'All Files (*.*)'
            }, 'Select Antenna Pattern File');
            if isequal(fname,0); return; end
            fullPath = fullfile(fpath, fname);
            app.Input_PatternField.Value = fullPath;
            try
                d = uiprogressdlg(app.UIFigure,'Title','Loading Data', 'Message','Please wait while the data is being loaded...', 'Indeterminate','on');
                app.filePath_raw = fullPath;
                app.patData = app.parsePatternFile();
                app.patData_raw = app.patData; % Lock in pristine anchor
                
                % Reset Global Spatial Kinematics explicitly upon parsing isolated topologies natively!
                app.RotMatrix = eye(3);
                
                % Detect Boresight Alignment Native Geometry Robustly
                app.autoDetectBoresight(app.patData);
                
                hdr = app.patData.header;
                freqStr = '';
                if ~isnan(app.patData.frequencyMHz)
                    freqStr = sprintf(' | Freq: %.1f MHz', app.patData.frequencyMHz);
                end
                app.Input_Label.Text = sprintf(...
                    'θ:[%.0f°,%.0f°] Δ%.1f° | φ:[%.0f°,%.0f°] Δ%.1f° | Max Gain: %.2f dBi | %d pts%s', ...
                    hdr.theta_min, hdr.theta_max, hdr.theta_inc, ...
                    hdr.phi_min, hdr.phi_max, hdr.phi_inc, ...
                    hdr.maximum_gain, numel(app.patData.theta), freqStr);
                app.Table_DataIn.Data = app.patData.data;
                % Adapt column names based on data format
                nCols = size(app.patData.data, 2);
                if app.patData.isGainOnly && nCols == 3
                    app.Table_DataIn.ColumnName = {'θ (°)','φ (°)','Gain (dB)'};
                    app.Label_GainCol.Visible = 'off';
                    app.DropDown_GainCol.Visible = 'off';
                elseif app.patData.isGainOnly && nCols > 3
                    colNames = cell(1,nCols);
                    colNames{1} = 'θ (°)'; colNames{2} = 'φ (°)';
                    for ci = 3:nCols; colNames{ci} = sprintf('Col %d', ci); end
                    colNames{app.patData.gainColIndex} = ['Gain (dB) [Col ' num2str(app.patData.gainColIndex) ']'];
                    app.Table_DataIn.ColumnName = colNames;
                    
                    app.Label_GainCol.Visible = 'on';
                    app.DropDown_GainCol.Visible = 'on';
                    ddItems = cell(1, nCols-2);
                    for ci = 3:nCols; ddItems{ci-2} = sprintf('Col %d', ci); end
                    app.DropDown_GainCol.Items = ddItems;
                    app.DropDown_GainCol.Value = sprintf('Col %d', app.patData.gainColIndex);
                else
                    app.Label_GainCol.Visible = 'off';
                    app.DropDown_GainCol.Visible = 'off';
                    app.Table_DataIn.ColumnName = {'θ (°)','φ (°)','Gθ (dB)','Gφ (dB)','∠Eθ (°)','∠Eφ (°)'};
                end
                close(d);
                processButtonPushed(app);
            catch ME
                try close(d); catch; end
                uialert(app.UIFigure, sprintf('%s\n(%s line %d)', ME.message, ME.stack(1).name, ME.stack(1).line), 'Load Error');
            end
        end

        % Value changed function: DropDown_GainCol
        function gainColChangedEvent(app, ~)
            if isempty(app.patData) || ~app.patData.isGainOnly; return; end
            idxStr = app.DropDown_GainCol.Value;
            colIdx = sscanf(idxStr, 'Col %d');
            
            % Update parsed data structure with new gain column directly avoiding hard drive reads
            app.patData.gainColIndex = colIdx;
            app.patData.G_theta_dB = app.patData.data(:, colIdx);
            app.patData.header.maximum_gain = max(app.patData.G_theta_dB);
            
            % Reset kinematic tracking and lock new pristine anchor
            app.RotMatrix = eye(3);
            app.patData_raw = app.patData;
            
            % Refresh Table Headers perfectly
            nCols = app.patData.numDataCols;
            colNames = cell(1,nCols);
            colNames{1} = 'θ (°)'; colNames{2} = 'φ (°)';
            for ci = 3:nCols; colNames{ci} = sprintf('Col %d', ci); end
            colNames{colIdx} = sprintf('Gain (dB) [Col %d]', colIdx);
            app.Table_DataIn.ColumnName = colNames;
            
            % Trigger downstream plots flawlessly
            app.processButtonPushed();
        end

        % Button pushed function: Button_Process
        function processButtonPushed(app, event)
            if isempty(app.patData); return; end
            params.Rw_dB   = app.Input_Rw.Value;
            params.Ptx_dBW = app.Input_Pt.Value;
            params.dist_m  = app.Input_Distance.Value;
            params.Loss_dB = app.Input_Loss.Value;
            try
                d = uiprogressdlg(app.UIFigure,'Title','Processing...','Indeterminate','on');
                app.results = app.computeAntennaMetrics(app.patData, params);
                T = app.results.table;
                app.Table_DataOut.Data = T;
                app.Table_DataOut.ColumnName = T.Properties.VariableNames;
                app.DominantPolLabel.Text = sprintf('Dom. Pol: %s', app.results.dominantPol);
                
                % Update Gain Peak
                [~,iMaxG] = max(app.results.G_total_dB);
                maxPeak = app.results.G_total_dB(iMaxG);
                app.Label_MaxGain.Text = sprintf('Peak Gain: %.2f dBi @ θ=%.0f° ϕ=%.0f°', maxPeak, app.results.theta(iMaxG), app.results.phi(iMaxG));
                
                % Dynamically Auto-Clamp Plot Display Limits to a 50dB range
                newCmax = ceil(maxPeak / 5) * 5;
                if newCmax < maxPeak; newCmax = newCmax + 5; end
                app.Input_Plot_Cmax.Value = newCmax;
                app.Input_Plot_Cmin.Value = newCmax - 50;
                
                % Compute and display directivity alongside peak gain
                D_dBi = app.computeDirectivity();
                if ~isnan(D_dBi)
                    app.Label_MaxGain.Text = sprintf('%s | D: %.2f dBi', app.Label_MaxGain.Text, D_dBi);
                end
                % Update E-Field Peak
                if isfield(app.results, 'isGainOnly') && app.results.isGainOnly
                    app.Label_MaxInputE.Text = 'Peak E: N/A (Gain Only)';
                else
                    magEth = abs(app.results.E_theta);
                    magEph = abs(app.results.E_phi);
                    [maxEth, iTh] = max(magEth);
                    [maxEph, iPh] = max(magEph);
                    if maxEth >= maxEph
                        vMax = maxEth; iM = iTh; cName = 'Eθ';
                    else
                        vMax = maxEph; iM = iPh; cName = 'Eϕ';
                    end
                    % app.Label_MaxInputE.Interpreter = 'tex';
                    app.Label_MaxInputE.Text = sprintf('Peak %s: %.2f @ θ=%g° ϕ=%g°', cName, vMax, app.results.theta(iM), app.results.phi(iM));
                end
                
                close(d);
                app.buildGridCache();
                updatePlots(app);
            catch ME
                try close(d); catch; end
                uialert(app.UIFigure, sprintf('%s\n(%s line %d)', ME.message, ME.stack(1).name, ME.stack(1).line), 'Processing Error');
            end
        end

        % ---- Build/refresh the cached grid (called once after processing) ----
        % Optimization: if the data lies on a regular theta×phi grid (which is
        % the common case for all simulation tools), we skip griddata entirely 
        % and use a fast reshape. griddata is only used as fallback for 
        % irregular/scattered data. This saves ~3-4 seconds per load.
        function buildGridCache(app)
            if isempty(app.results); return; end
            r = app.results;
            
            thU = unique(r.theta);
            phU = unique(r.phi);
            nData = numel(r.theta);
            
            % Protect against Out Of Memory (OOM) meshgrid explosion 
            % If the geometry was geometrically rotated via Spherical Cosines, 
            % floating-point indices scatter into completely irregular arrays
            % resulting in `nTh` jumping from 181 to >60,000 -> crashing meshgrid.
            isRegularGrid = false;
            
            % Relaxed equality accommodates wrap seams (e.g. duplicating Phi=360)
            if (numel(thU) * numel(phU) == nData) || (numel(thU) * (numel(phU)-1) == nData)
                isRegularGrid = true;
            end
            
            % If unique indices explode geometrically, enforce native resolution grids explicitly
            if ~isRegularGrid && (numel(thU) > 800 || numel(phU) > 800)
                th_inc = r.header.theta_inc;
                ph_inc = r.header.phi_inc;
                if isempty(th_inc) || isnan(th_inc) || th_inc <= 0; th_inc = 1; end
                if isempty(ph_inc) || isnan(ph_inc) || ph_inc <= 0; ph_inc = 1; end
                
                g.thVec = linspace(0, 180, round(180/th_inc) + 1)';
                g.phVec = linspace(0, 360, round(360/ph_inc) + 1)';
            else
                g.thVec = thU(:);
                g.phVec = phU(:);
            end
            
            g.nTh = numel(g.thVec);
            g.nPh = numel(g.phVec);
            
            % Establish the unified 2D mesh grid
            [g.PHI, g.THETA] = meshgrid(g.phVec, g.thVec);
            g.TH_rad = deg2rad(g.THETA); g.PH_rad = deg2rad(g.PHI);
            
            % Unit-sphere Cartesian (for 3D sphere plot)
            g.Xs = sin(g.TH_rad).*cos(g.PH_rad);
            g.Ys = sin(g.TH_rad).*sin(g.PH_rad);
            g.Zs = cos(g.TH_rad);
            
            % Polar-plot Cartesian ([x,y] = pol2cart(Ang,Rho))
            [g.Xc, g.Yc] = pol2cart(deg2rad(g.PHI), g.THETA);
            
            if isRegularGrid
                % --- FAST PATH: regular grid → sort + reshape (no griddata) ---
                % Sort phi-major so reshape fills column-major correctly:
                % Column j of the nTh×nPh matrix = all thetas at phVec(j)
                [~, sortIdx] = sortrows([r.theta, r.phi], [2, 1]);
                T_sort = r.G_total_dB(sortIdx);
                Rhcp_sort = r.E_RHCP_dB(sortIdx);
                Lhcp_sort = r.E_LHCP_dB(sortIdx);
                AR_sort = r.AR_dB(sortIdx);
                Pol_sort = r.G_polCorrected_dB(sortIdx);
                
                % Fallback dimension protector before fast-path 
                if numel(T_sort) == g.nTh * g.nPh
                    g.G_tot  = reshape(T_sort,    g.nTh, g.nPh);
                    g.G_rhcp = reshape(Rhcp_sort, g.nTh, g.nPh);
                    g.G_lhcp = reshape(Lhcp_sort, g.nTh, g.nPh);
                    g.AR_dB  = reshape(AR_sort,   g.nTh, g.nPh);
                    g.G_pol  = reshape(Pol_sort,  g.nTh, g.nPh);
                else
                    % Trigger graceful degradation if indices shifted heavily
                    isRegularGrid = false;
                end
            end
            
            if ~isRegularGrid
                % --- SLOW PATH: irregular/scattered data → griddata topology mapping ---
                % Safely pad explicit azimuthal seam overlaps ensuring the algorithm interpolates the border wraps properly completely avoiding edge-distortion!
                pad_phi = [r.phi(:); r.phi(:) - 360; r.phi(:) + 360];
                pad_th  = [r.theta(:); r.theta(:); r.theta(:)];
                
                g.G_tot  = griddata(pad_phi, pad_th, [r.G_total_dB(:); r.G_total_dB(:); r.G_total_dB(:)],                      g.PHI, g.THETA, 'linear');
                g.G_rhcp = griddata(pad_phi, pad_th, [r.E_RHCP_dB(:); r.E_RHCP_dB(:); r.E_RHCP_dB(:)],                         g.PHI, g.THETA, 'linear');
                g.G_lhcp = griddata(pad_phi, pad_th, [r.E_LHCP_dB(:); r.E_LHCP_dB(:); r.E_LHCP_dB(:)],                         g.PHI, g.THETA, 'linear');
                g.AR_dB  = griddata(pad_phi, pad_th, [r.AR_dB(:); r.AR_dB(:); r.AR_dB(:)],                                     g.PHI, g.THETA, 'linear');
                g.G_pol  = griddata(pad_phi, pad_th, [r.G_polCorrected_dB(:); r.G_polCorrected_dB(:); r.G_polCorrected_dB(:)], g.PHI, g.THETA, 'linear');
            end
            
            app.cachedGrid = g;
        end

        % ---- Full plot refresh (pattern surfaces + cuts) ----
        function updatePlots(app)
            app.updatePatternPlots();
            app.updateCutPlots();
        end

        % ---- Pattern surfaces only (contour, circular, 3D) ----
        function updatePatternPlots(app)
            if isempty(app.results); return; end
            if isempty(app.cachedGrid); app.buildGridCache(); end
            r = app.results;
            g = app.cachedGrid;

            % Select data field based on component dropdown
            compVal = app.DropDown_Component.Value;
            switch compVal
                case 'Total Gain';      Zg = g.G_tot;            cLabel = 'Total Gain (dBi)';
                case 'RHCP Gain';       Zg = g.G_rhcp;           cLabel = 'RHCP Gain (dBi)';
                case 'LHCP  Gain';      Zg = g.G_lhcp;           cLabel = 'LHCP Gain (dBi)';  % Note: double space matches UI item string
                case 'Axial Ratio';     Zg = g.AR_dB;            cLabel = 'Axial Ratio (dB)';
                case 'Polarized Gain';  Zg = g.G_pol;            cLabel = 'Polarized Gain (dBi)';
                otherwise;              Zg = g.G_tot;            cLabel = 'Total Gain (dBi)';
            end

            cmin  = app.Input_Plot_Cmin.Value;
            cmax  = app.Input_Plot_Cmax.Value;
            cmap = jet; % Colormap definitions: colormap(app.Axes_Contour, 'jet'); % Standard ergonomic colormap (JET)
            ZFormat = '%.2g dBi';
            
            if strcmp(compVal, 'Axial Ratio')
                cm = max(abs(cmin), abs(cmax));
                cmin = -cm; cmax = cm;               

                % Colormap definitions: Thermometer-like bichromatic palette (OriginPro-like style)
                N_cmap = 255;
                cmap = double([N_cmap*ones(1,N_cmap), N_cmap:-1:0; 0:N_cmap-1, N_cmap:-1:0; 0:N_cmap, N_cmap*ones(1,N_cmap)].') / 255;
                ZFormat = '%.2g dB';
            end

            % Preserve raw un-clipped values for accurate 3D geometry scaling
            Zg_raw = Zg;

            % Clamp to colour range explicitly for 2D map shadings
            Zg = max(Zg, cmin);   % clamp below → lowest colormap colour
            Zg = min(Zg, cmax);   % clamp above → highest colormap colour

            % --- Contour Plot (pcolor for smooth fills, no contour lines) ---
            ax1 = app.Axes_Contour; 
            cla(ax1);
            % hCtr = contourf(ax1, g.PHI, g.THETA, Zg, cmin:0.1:cmax, 'LineStyle', 'none', DisplayName='Antenna Gain Pattern'); shading(ax1, 'interp');
            hCtr = pcolor(ax1, g.PHI, g.THETA, Zg, FaceColor="interp", LineStyle="none"); % hCtr.FaceColor = 'interp'; % shading(ax1, 'interp');

            dt = datatip(hCtr, 0, 0); % Create a temp/dummy datatip
            delete(dt); % Delete it, initialized DataTipTemplate remains
            hCtr.DataTipTemplate.DataTipRows(1) = dataTipTextRow('\theta', g.THETA, '%g\x00B0');
            hCtr.DataTipTemplate.DataTipRows(2) = dataTipTextRow('\phi', g.PHI, '%g\x00B0');
            hCtr.DataTipTemplate.DataTipRows(3) = dataTipTextRow('Mag', Zg, ZFormat); % avoid hCtr.ZData = hCtr.CData; % To display actual Z-levels/Gain-levels upon hover (data tip)

            colormap(ax1, cmap);
            cb1 = colorbar(ax1); cb1.Label.String = cLabel; % No need for title since it's included in Colormap Label % title(ax1, cLabel);
            xlabel(ax1, '\phi (°)'); ylabel(ax1, '\theta (°)');
            set(ax1, 'YDir','reverse', 'CLim',[cmin cmax], 'XLim',[0 360], 'YLim',[0 180], 'XTick',0:30:360, 'YTick',0:15:180);
            % Layer='top' forces axes box/ticks to render ABOVE the pcolor surface
            ax1.Layer = 'top'; ax1.Box = 'on';
            if app.CheckBox_Grid.Value
                hold(ax1, 'on');
                for y = 15:15:165
                  plot(ax1, [0 360], [y y], '-', 'Color', [0.8 0.8 0.8 0.5], 'HitTest', 'off', 'PickableParts', 'none');
                end
                for x = 30:30:330
                  plot(ax1, [x x], [0 180], '-', 'Color', [0.8 0.8 0.8 0.5], 'HitTest', 'off', 'PickableParts', 'none');
                end
                hold(ax1, 'off');
            end

            % --- Circular/Polar Contour Plot ---
            ax2 = app.Axes_Circular;
            cla(ax2);
            
            % Polar Skyplot (Fisheye Projection): Polar to Cartesian ([x,y] = pol2cart(Ang,Rho)) % rho = Theta, Ang = Phi
            % [X_sky, Y_sky] = pol2cart(deg2rad(g.PHI), g.THETA); % X_sky = g.THETA .* sind(g.PHI); Y_sky = g.THETA .* cosd(g.PHI);
            
            hSky = pcolor(ax2, g.Xc, g.Yc, Zg, FaceColor="interp", LineStyle="none"); % shading(ax2, 'interp'); % contourf(X, Y, Zg, 50, 'LineColor', 'none'); 
            dt = datatip(hSky, 0, 0); delete(dt);
            hSky.DataTipTemplate.DataTipRows(1) = dataTipTextRow('\theta', g.THETA, '%g\x00B0');
            hSky.DataTipTemplate.DataTipRows(2) = dataTipTextRow('\phi', g.PHI, '%g\x00B0');
            hSky.DataTipTemplate.DataTipRows(3) = dataTipTextRow('Mag', Zg, ZFormat);
            
            colormap(ax2, cmap);
            hold(ax2, 'on');

            % Polar grid lines (thin)
            % --- Circular grid rings at regular θ intervals ---
            ang = linspace(0, 2*pi, 361);
            ringStep = 30;
            for r = ringStep:ringStep:180 % 30:30:180
                if app.CheckBox_Grid.Value
                    plot(ax2, r*cos(ang), r*sin(ang), '-', 'Color', [0.8 0.8 0.8 0.5], 'LineWidth', 0.5, 'HitTest', 'off', 'PickableParts', 'none'); % [R G B Alpha] % next try 'Color', [0.7 0.7 0.7 0.5]
                end
                text(ax2, r*sind(15)+2, r*cosd(15)+2, ['\theta=' num2str(r) '^\circ'], 'Color', 'w', 'FontSize', 8, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'HitTest', 'off', 'PickableParts', 'none');
            end
            
            if app.CheckBox_Grid.Value
                plot(ax2, 180*cos(ang), 180*sin(ang), '-', 'Color', [0.6 0.6 0.6 0.7], 'LineWidth', 0.8, 'HitTest', 'off', 'PickableParts', 'none');
            end
            % --- Radial spoke lines every 45° ---
            for p = 0:45:315
                if app.CheckBox_Grid.Value
                    plot(ax2, [0 180*sind(p)], [0 180*cosd(p)], '-', 'Color', [0.8 0.8 0.8 0.5], 'LineWidth', 0.5, 'HitTest', 'off', 'PickableParts', 'none'); % next try 'Color', [0.7 0.7 0.7 0.5]
                end

                % Coordinate projection mapping the azimuthal...
                text(ax2, (180+20)*sind(p), (180+20)*cosd(p), ['\phi=' num2str(p) '^\circ'], 'Color', [0.15 0.15 0.15], 'FontSize', 9, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'HitTest', 'off', 'PickableParts', 'none');
            end
            hold(ax2, 'off');

            % xlabel(ax2, ''); ylabel(ax2, ''); % No need for, because now labels are not specified when creating the UIAxes
            clim(ax2, [cmin cmax]);
            cb2 = colorbar(ax2); cb2.Label.String = cLabel; % No need for title since it's included in Colormap Label % title(ax2, cLabel, 'Units', 'normalized', 'Position', [0.5, 0.98, 0]);
            % ax2.Layer = 'bottom'; % Try to place the grid lines on Bottom to ensure data is on top of the grid
            % ax2.Interactions = dataTipInteraction('SnapToDataVertex', 'on'); % Force Data Tips Snap to Data Only
            
            % Set tight zoomed boundary dynamically scaled to +10% padding so text labels never truncate against plot boundaries
            % Force the boundaries of the invisible frame holding the graph to be mathematically larger than the graph itself!
            paddedMax = max(180 * 1.1, 0.1); % Pull the transparent boundaries back inwards to strictly 10% whitespace
            axis(ax2, [-paddedMax paddedMax -paddedMax paddedMax]);
            axis(ax2, 'equal'); axis(ax2, 'off');

            % --- 3D Spherical Surface Contour Plot (color = gain, radius = 1) ---
            ax3 = app.Axes_Spherical; cla(ax3);
            
            % Preserve the user's camera angle BEFORE matrix refresh sweeps!
            [az3, el3] = view(ax3); %az3 = ax3.View(1); el3 = ax3.View(2);
            
            hSurf3D = surf(ax3, g.Xs, g.Ys, g.Zs, Zg, 'EdgeColor','none','FaceColor','interp', 'FaceAlpha',1);
                        
            dt = datatip(hSurf3D, 0, 0, 0); delete(dt);
            hSurf3D.DataTipTemplate.DataTipRows(1) = dataTipTextRow('\theta', g.THETA, '%g\x00B0');
            hSurf3D.DataTipTemplate.DataTipRows(2) = dataTipTextRow('\phi', g.PHI, '%g\x00B0');
            hSurf3D.DataTipTemplate.DataTipRows(3) = dataTipTextRow('Mag', Zg, ZFormat);
            
            colormap(ax3, cmap);
            xlabel(ax3,'X'); ylabel(ax3,'Y'); zlabel(ax3,'Z');
            clim(ax3, [cmin cmax]);
            cb3 = colorbar(ax3); cb3.Label.String = cLabel;
            axis(ax3, 'equal');
            axis(ax3, 'tight');
            axis(ax3, 'off');
            
            % Lock spatial boundaries symmetrically to precisely 1.16 (Radius 1 + 16% margin)
            % This permanently stops the camera zoom from dancing when toggling positive/negative axes grids!
            axis(ax3, [-1.16 1.16 -1.16 1.16 -1.16 1.16]);
            
            app.add_3d_axes(ax3, 1.15, app.CheckBox_NegAxes.Value);
            if app.CheckBox_Grid.Value
                hold(ax3, 'on');
                gColor3D = [0.8 0.8 0.8 0.5];
                th_grid = 30:30:180; ph_arr = linspace(0, 360, 361);
                for th = th_grid
                    plot3(ax3, sind(th)*cosd(ph_arr), sind(th)*sind(ph_arr), cosd(th)*ones(size(ph_arr)), '-', 'Color', gColor3D, 'LineWidth', 0.5, 'HitTest', 'off', 'PickableParts', 'none');
                end
                ph_grid = 0:45:315; th_arr = linspace(0, 180, 181);
                for ph = ph_grid
                    plot3(ax3, sind(th_arr)*cosd(ph), sind(th_arr)*sind(ph), cosd(th_arr), '-', 'Color', gColor3D, 'LineWidth', 0.5, 'HitTest', 'off', 'PickableParts', 'none');
                end
                hold(ax3, 'off');
            end
            % Restore saved camera view after all graphics are added
            view(ax3, az3, el3);

            % --- 3D Pattern (radius = gain-scaled magnitude) ---
            ax4 = app.Axes_3D; cla(ax4);
            
            % Preserve the user's camera angle across sweeps! Grab parameters BEFORE object clear trigger!
            [az4, el4] = view(ax4);
            
            % Why Zg_safe & R3? 
            % 'Zg_raw' is structural gain values natively stretching across ranges (eg. [-40 dBi to +10 dBi]).
            % 'cmin' is the minimum threshold (e.g., -10 dBi).
            % Radiation plotting physics demands that ANY gain less than the threshold is flattened 
            % rigidly to R=0 to prevent negative radii looping in backwards spherical space identically mapping 
            % 'radiationpattern3D.m' logic `r = MagE1 - minval`.
            Zg_safe = max(Zg_raw, cmin); % Prevent -Inf singularities pointing backwards
            R3 = Zg_safe - cmin; % Volumetric scaling naturally anchored to scale floor
            maxR = max(R3(:));
            
            Xp = R3.*sin(g.TH_rad).*cos(g.PH_rad);
            Yp = R3.*sin(g.TH_rad).*sin(g.PH_rad);
            Zp = R3.*cos(g.TH_rad);
            
            % Map the color strictly through the clamped Zg
            hSurfPat = surf(ax4, Xp, Yp, Zp, Zg, 'EdgeColor','none','FaceColor','interp', 'FaceAlpha',1);
                        
            dt = datatip(hSurfPat, 0, 0, 0); delete(dt);
            hSurfPat.DataTipTemplate.DataTipRows(1) = dataTipTextRow('\theta', g.THETA, '%g\x00B0');
            hSurfPat.DataTipTemplate.DataTipRows(2) = dataTipTextRow('\phi', g.PHI, '%g\x00B0');
            hSurfPat.DataTipTemplate.DataTipRows(3) = dataTipTextRow('Mag', Zg, ZFormat);

            colormap(ax4, cmap);
            xlabel(ax4,'X'); ylabel(ax4,'Y'); zlabel(ax4,'Z');
            clim(ax4, [cmin cmax]);
            cb4 = colorbar(ax4); cb4.Label.String = cLabel;
            axis(ax4, 'equal');
            axis(ax4, 'tight');
            axis(ax4, 'off');
            if maxR < 0.001; maxR = 1; end
            
            % Lock spatial boundaries symmetrically mapped identically to ax3's proportionality constraints
            axis(ax4, [-maxR*1.16 maxR*1.16 -maxR*1.16 maxR*1.16 -maxR*1.16 maxR*1.16]);

            app.add_3d_axes(ax4, maxR * 1.15, app.CheckBox_NegAxes.Value);
            if app.CheckBox_Grid.Value
                hold(ax4, 'on');
                gColor3D = [0.8 0.8 0.8 0.5];
                for th = 30:30:180
                    [~, iTh] = min(abs(g.thVec - th));
                    plot3(ax4, Xp(iTh, :), Yp(iTh, :), Zp(iTh, :), '-', 'Color', gColor3D, 'LineWidth', 0.5, 'HitTest', 'off', 'PickableParts', 'none');
                end
                for ph = 0:45:315
                    [~, iPh] = min(abs(g.phVec - ph));
                    plot3(ax4, Xp(:, iPh), Yp(:, iPh), Zp(:, iPh), '-', 'Color', gColor3D, 'LineWidth', 0.5, 'HitTest', 'off', 'PickableParts', 'none');
                end
                hold(ax4, 'off');
            end
            % Restore saved camera view after all graphics are added
            view(ax4, az4, el4);
        end

        % ════════════════════════════════════════════════════════════════
        %  AUTOMATED SPHERICAL BORESIGHT DETECTION
        % ════════════════════════════════════════════════════════════════
        function autoDetectBoresight(app, pat)
            % Calculates the integral mean of total field gain strictly within 
            % a solid angle cone mapping the 6 primary Cartesian hemispheres 
            % to prevent isolated high-frequency spikes from skewing alignment
            
            if pat.isGainOnly && ~isfield(pat, 'G_phi_dB')
                % Gain-only specific format without intrinsic component geometry
                g_lin = 10.^(pat.G_theta_dB / 10);
            else
                % Fully constrained Spherical Component Array summing Linear Power Fields natively
                g_lin = 10.^(pat.G_theta_dB / 10);
                if isfield(pat, 'G_phi_dB') && ~all(isnan(pat.G_phi_dB))
                    g_lin = g_lin + 10.^(pat.G_phi_dB / 10);
                end
            end
            
            % Resolve vector dataset across spherical coordinates natively
            th_r = deg2rad(pat.theta);
            ph_r = deg2rad(pat.phi);
            v_data = [sin(th_r).*cos(ph_r), sin(th_r).*sin(ph_r), cos(th_r)];
            
            % Primary alignment axes mapping orthogonal space
            axes_vecs = [1, 0, 0; -1, 0, 0; 0, 1, 0; 0, -1, 0; 0, 0, 1; 0, 0, -1];
            labels = {'Source: +X (Forward)', 'Source: -X (Aft)', 'Source: +Y (Stbd)', 'Source: -Y (Port)', 'Source: +Z (Overhead)', 'Source: -Z (Deck)'};
            
            best_val = -Inf;
            best_idx = 5; % Defaults conservatively to +Z (Overhead)
            t_cos = cos(deg2rad(45)); % Solid angle integration cone constraint bounding calculations exclusively
            
            for i = 1:6
                dp = v_data * axes_vecs(i, :)';
                mask = dp >= t_cos;
                if any(mask)
                    avg_g = mean(g_lin(mask), 'omitnan');
                    if avg_g > best_val
                        best_val = avg_g;
                        best_idx = i;
                    end
                end
            end
            
            % Apply detected geometry seamlessly
            app.DropDown_InitOri.Value = labels{best_idx};
            app.syncSourceOrientationSpinners([]);
        end

        % ════════════════════════════════════════════════════════════════
        %  UI CALLBACK: Dynamic E-Plane / H-Plane Extraction Tracker
        % ════════════════════════════════════════════════════════════════
        function planeModeChangedEvent(app, ~)
            mode = app.DropDown_PlaneMode.Value;
            if strcmp(mode, 'Manual Cut')
                app.DropDown_CutType.Enable = 'on';
                app.Input_Cut_Value.Enable = 'on';
                return;
            end
            
            % Resolve geometry mapping natively from current Source Coordinates
            if isempty(app.patData); return; end
            
            th = app.Input_SrcTheta.Value;
            ph = app.Input_SrcPhi.Value;
            
            % Interpolate exact Dominant Polarization natively
            [~, idx] = min((app.patData.theta - th).^2 + (app.patData.phi - ph).^2);
            E_th = app.patData.G_theta_dB(idx);
            E_ph = app.patData.G_phi_dB(idx);
            
            is_th_dom = false;
            if ~isnan(E_th) && (isnan(E_ph) || E_th > E_ph)
                is_th_dom = true;
            end
            
            ori = app.DropDown_InitOri.Value;
            if contains(ori, 'X')
                if contains(ori, '-'); ph_xz = 180; else; ph_xz = 0; end
                if is_th_dom    e_p = {'Theta Cut', ph_xz}; h_p = {'Phi Cut', 90};
                else            e_p = {'Phi Cut', 90}; h_p = {'Theta Cut', ph_xz};
                end
            elseif contains(ori, 'Y')
                if contains(ori, '-'); ph_yz = 270; else; ph_yz = 90; end
                if is_th_dom
                    e_p = {'Theta Cut', ph_yz}; h_p = {'Phi Cut', 90};
                else
                    e_p = {'Phi Cut', 90}; h_p = {'Theta Cut', ph_yz};
                end
            else
                % Zenith default natively - Sweep Theta while holding Phi constant
                if is_th_dom
                    e_p = {'Theta Cut', 0}; h_p = {'Theta Cut', 90};
                else
                    e_p = {'Theta Cut', 90}; h_p = {'Theta Cut', 0};
                end
            end
            
            % Apply bounded assignments
            if strcmp(mode, 'Auto E-Plane')
                app.DropDown_CutType.Value = e_p{1};
                app.Input_Cut_Value.Value = e_p{2};
            else
                app.DropDown_CutType.Value = h_p{1};
                app.Input_Cut_Value.Value = h_p{2};
            end
            
            app.DropDown_CutType.Enable = 'off';
            app.Input_Cut_Value.Enable = 'off';
            
            % Dynamic plot transition natively
            app.updateCutPlotsEvent([]);
        end

        % ════════════════════════════════════════════════════════════════
        %  UI CALLBACK: Synchronize Source UI Dynamically
        % ════════════════════════════════════════════════════════════════
        function syncSourceOrientationSpinners(app, ~)
            srcStr = app.DropDown_InitOri.Value;
            if contains(srcStr, '+X');      th=90; ph=0;
            elseif contains(srcStr, '-X');  th=90; ph=180;
            elseif contains(srcStr, '+Y');  th=90; ph=90;
            elseif contains(srcStr, '-Y');  th=90; ph=270;
            elseif contains(srcStr, '+Z');  th=0;  ph=0;
            elseif contains(srcStr, '-Z');  th=180;ph=0;
            else;                           return;
            end
            app.Input_SrcTheta.Value = th;
            app.Input_SrcPhi.Value = ph;
            app.planeModeChangedEvent([]);
        end
        
        function setSourceCustomMode(app, ~)
            app.DropDown_InitOri.Value = 'Custom...';
        end

        % ════════════════════════════════════════════════════════════════
        %  UI CALLBACK: Rotate Spherical Pattern natively
        % ════════════════════════════════════════════════════════════════
        function rotatePatternButtonPushed(app, ~)
            if isempty(app.patData) || isempty(app.results); return; end
            
            rotTh_deg = app.Input_RotTheta.Value;
            rotPh_deg = app.Input_RotPhi.Value;
            
            d = uiprogressdlg(app.UIFigure, 'Title','Spherical Rotation', 'Message','Applying Spherical Law of Cosines Translation...', 'Indeterminate','on');
            try
                % =========================================================================
                % ABSOLUTE VECTOR TARGETING KINEMATICS (Rodrigues' Formulation)
                % =========================================================================
                dst_th = deg2rad(rotTh_deg);
                dst_ph = deg2rad(rotPh_deg);
                
                % 1. Determine Initial Boresight Source Vector Explicitly
                srcStr = app.DropDown_InitOri.Value;
                if contains(srcStr, '+X');      v_s = [1; 0; 0];
                elseif contains(srcStr, '-X');  v_s = [-1; 0; 0];
                elseif contains(srcStr, '+Y');  v_s = [0; 1; 0];
                elseif contains(srcStr, '-Y');  v_s = [0; -1; 0];
                elseif contains(srcStr, '+Z');  v_s = [0; 0; 1];
                elseif contains(srcStr, '-Z');  v_s = [0; 0; -1];
                else
                    % CUSTOM ORIENTATION: Extract spherical coordinates and map to 3D Cartesian
                    c_th = deg2rad(app.Input_SrcTheta.Value);
                    c_ph = deg2rad(app.Input_SrcPhi.Value);
                    v_s = [sin(c_th)*cos(c_ph); sin(c_th)*sin(c_ph); cos(c_th)];
                end
                
                % Ensure normalized vector rigorously
                v_s = v_s / norm(v_s);
                
                % 2. Calculate Destination Spherical Target explicitly preserving geometry
                v_d = [sin(dst_th)*cos(dst_ph); sin(dst_th)*sin(dst_ph); cos(dst_th)];
                if norm(v_s - v_d) < 1e-6
                    close(d);
                    return;
                end
                
                % 3. Rodrigues' Optimal 3D Formulation mapping Absolute Transform rigorously without Euler Sequences
                k = cross(v_s, v_d);
                sin_rot = norm(k);
                cos_rot = dot(v_s, v_d);
                
                if sin_rot < 1e-12
                    if cos_rot > 0
                        % Collinear Identical Direction (0 shift)
                        R = eye(3);
                    else
                        % 180-Degree Polarity Flip across Orthogonal Plane
                        if abs(v_s(1)) < 0.9; ortho = [1; 0; 0];
                        else;                 ortho = [0; 1; 0];
                        end
                        k_flip = cross(v_s, ortho);
                        k_flip = k_flip / norm(k_flip);
                        K = [0 -k_flip(3) k_flip(2); k_flip(3) 0 -k_flip(1); -k_flip(2) k_flip(1) 0];
                        R = eye(3) + 2 * (K * K);
                    end
                else
                    % Generic Absolute Mapping Geometry
                    k = k / sin_rot;
                    K = [0 -k(3) k(2); k(3) 0 -k(1); -k(2) k(1) 0];
                    R = eye(3) + sin_rot * K + (1 - cos_rot) * (K * K);
                end
                
                % 4. Absolute structural override eliminating compounding recursion loops inherently!
                app.RotMatrix = R * app.RotMatrix;
                
                % =========================================================================
                % FAST INVERSE KINEMATIC RESAMPLING
                % Computes the exact measurement grid inverse to perfectly preserve structured topology
                % =========================================================================
                d.Message = 'Executing Inverse Kinematic Mapping...';
                
                % 1. Extract 1D vectors representing the perfectly structured source grid
                %    (We rely on the data being logically regular 1xN vectors)
                th_orig = unique(app.patData_raw.theta);
                ph_orig = unique(app.patData_raw.phi);
                if isrow(th_orig); th_orig = th_orig'; end
                if isrow(ph_orig); ph_orig = ph_orig'; end
                
                % E-Field Base Complex Amplitudes (Pristine Anchor)
                E_th_mag  = 10.^(app.patData_raw.G_theta_dB / 20);
                E_ph_mag  = 10.^(app.patData_raw.G_phi_dB / 20);
                E_th_cplx = E_th_mag .* exp(1j * deg2rad(app.patData_raw.phase_E_theta));
                E_ph_cplx = E_ph_mag .* exp(1j * deg2rad(app.patData_raw.phase_E_phi));
                
                % Convert to Cartesian vectors locally for interpolation
                th_base = deg2rad(app.patData_raw.theta);
                ph_base = deg2rad(app.patData_raw.phi);
                thx = cos(th_base).*cos(ph_base); thy = cos(th_base).*sin(ph_base); thz = -sin(th_base);
                phx = -sin(ph_base);              phy = cos(ph_base);              phz = zeros(size(ph_base));
                E_X = E_th_cplx .* thx + E_ph_cplx .* phx;
                E_Y = E_th_cplx .* thy + E_ph_cplx .* phy;
                E_Z = E_th_cplx .* thz + E_ph_cplx .* phz;
                
                % 2. Define the exact same structured TARGET integer grid
                %    The target coordinates never change, preserving exact topology!
                [PHI_out, TH_out] = meshgrid(ph_orig, th_orig);
                th_out_rad = deg2rad(TH_out);
                ph_out_rad = deg2rad(PHI_out);
                
                % Convert target output grid points to Cartesian unit vectors
                X_out = sin(th_out_rad) .* cos(ph_out_rad);
                Y_out = sin(th_out_rad) .* sin(ph_out_rad);
                Z_out = cos(th_out_rad);
                
                % 3. Inverse Coordinate Mapping
                %    Where did these target points come from in the original frame?
                %    V_mapped = R_inv * V_out
                R_inv = app.RotMatrix'; % Transpose is inverse for standard rotation matrices
                X_map = R_inv(1,1).*X_out + R_inv(1,2).*Y_out + R_inv(1,3).*Z_out;
                Y_map = R_inv(2,1).*X_out + R_inv(2,2).*Y_out + R_inv(2,3).*Z_out;
                Z_map = R_inv(3,1).*X_out + R_inv(3,2).*Y_out + R_inv(3,3).*Z_out;
                
                th_map = reshape(acos(max(min(Z_map, 1), -1)), size(TH_out));
                ph_map = reshape(atan2(Y_map, X_map), size(PHI_out));
                ph_map(ph_map < 0) = ph_map(ph_map < 0) + 2*pi;
                
                th_map_deg = rad2deg(th_map);
                ph_map_deg = rad2deg(ph_map);
                
                % 4. Fast Interpolation
                d.Message = 'Applying high-fidelity 2D Akima Resampling...';
                
                % Format raw columns to 2D grids for interp2
                [PHI_in, TH_in] = meshgrid(ph_orig, th_orig);
                
                % Sort data correctly to match the meshgrid structure perfectly
                % interp2 requires monotonically increasing grid vectors
                P_grid = zeros(numel(th_orig), numel(ph_orig));
                map_idx = sub2ind([numel(th_orig), numel(ph_orig)], ...
                    interp1(th_orig, 1:numel(th_orig), app.patData_raw.theta, 'nearest'), ...
                    interp1(ph_orig, 1:numel(ph_orig), app.patData_raw.phi, 'nearest'));
                
                ExR = P_grid; ExR(map_idx) = real(E_X);
                ExI = P_grid; ExI(map_idx) = imag(E_X);
                EyR = P_grid; EyR(map_idx) = real(E_Y);
                EyI = P_grid; EyI(map_idx) = imag(E_Y);
                EzR = P_grid; EzR(map_idx) = real(E_Z);
                EzI = P_grid; EzI(map_idx) = imag(E_Z);
                
                % makima interpolation preserves peaks beautifully without ringing
                X_int_R = interp2(PHI_in, TH_in, ExR, ph_map_deg, th_map_deg, 'makima');
                X_int_I = interp2(PHI_in, TH_in, ExI, ph_map_deg, th_map_deg, 'makima');
                Y_int_R = interp2(PHI_in, TH_in, EyR, ph_map_deg, th_map_deg, 'makima');
                Y_int_I = interp2(PHI_in, TH_in, EyI, ph_map_deg, th_map_deg, 'makima');
                Z_int_R = interp2(PHI_in, TH_in, EzR, ph_map_deg, th_map_deg, 'makima');
                Z_int_I = interp2(PHI_in, TH_in, EzI, ph_map_deg, th_map_deg, 'makima');
                
                Ex_int = X_int_R + 1j*X_int_I;
                Ey_int = Y_int_R + 1j*Y_int_I;
                Ez_int = Z_int_R + 1j*Z_int_I;
                
                % 5. Forward rotate interpolated field physical vectors to the new global frame
                d.Message = 'Projecting physical vectors...';
                
                Ex_rot = app.RotMatrix(1,1).*Ex_int + app.RotMatrix(1,2).*Ey_int + app.RotMatrix(1,3).*Ez_int;
                Ey_rot = app.RotMatrix(2,1).*Ex_int + app.RotMatrix(2,2).*Ey_int + app.RotMatrix(2,3).*Ez_int;
                Ez_rot = app.RotMatrix(3,1).*Ex_int + app.RotMatrix(3,2).*Ey_int + app.RotMatrix(3,3).*Ez_int;
                
                % Project rotated global Cartesian vectors onto target spherical local tangents
                th_hat_rot_x = cos(th_out_rad).*cos(ph_out_rad); 
                th_hat_rot_y = cos(th_out_rad).*sin(ph_out_rad); 
                th_hat_rot_z = -sin(th_out_rad);
                
                ph_hat_rot_x = -sin(ph_out_rad);
                ph_hat_rot_y = cos(ph_out_rad);
                ph_hat_rot_z = zeros(size(ph_out_rad));
                
                Eth_new = Ex_rot.*th_hat_rot_x + Ey_rot.*th_hat_rot_y + Ez_rot.*th_hat_rot_z;
                Eph_new = Ex_rot.*ph_hat_rot_x + Ey_rot.*ph_hat_rot_y + Ez_rot.*ph_hat_rot_z;
                
                % Extract exactly back to flat list mapped strictly against input structure
                rotPat = app.patData;
                rotPat.G_theta_dB = 20 * log10(max(abs(Eth_new(map_idx)), 1e-15));
                rotPat.G_phi_dB   = 20 * log10(max(abs(Eph_new(map_idx)), 1e-15));
                rotPat.phase_E_theta = rad2deg(angle(Eth_new(map_idx)));
                rotPat.phase_E_phi   = rad2deg(angle(Eph_new(map_idx)));
                % theta and phi are NOT updated! They strictly retain the perfect integer base grid.
                
                app.patData = rotPat;
                
                % Execute complete Metrics recalculation universally mapping the array
                app.results = app.computeAntennaMetrics(app.patData, app.results.params);
                % Input Data doesn't need overwrite since structure didn't distort
                app.Table_DataOut.Data = app.results.table;
                
                % UI Syncing
                app.DropDown_InitOri.Value = 'Custom...';
                app.Input_SrcTheta.Value = rotTh_deg;
                app.Input_SrcPhi.Value = rotPh_deg;
                
                close(d);
                app.buildGridCache();  % This will hit the fast exact-lattice path now!
                app.updatePlots();
                
            catch ME
                try close(d); catch; end
                uialert(app.UIFigure, sprintf('Rotation failed: %s\n', ME.message), 'Error');
            end
        end

        % ---- Cut plots only (polar + rectangular + filled polar) ----
        function updateCutPlots(app)
            if isempty(app.results); return; end

            cmin  = app.Input_Plot_Cmin.Value;
            cmax  = app.Input_Plot_Cmax.Value;
            cstep = app.Input_Plot_Cstep.Value;

            % Determine which component is selected so the filled polar can match
            compVal = app.DropDown_Component.Value;

            % --- Extract Cut ---
            [cutAngle, cutData, cutLabel] = app.extractCut();
            if strcmp(app.DropDown_CutType.Value, 'Phi Cut')
                xStr = '\phi'; xLbl = '\phi (°)';
            else
                xStr = '\theta'; xLbl = '\theta (°)';
            end

            % --- Polar Cut ---
            cla(app.pax, 'reset');
            app.pax.ThetaZeroLocation = 'top';
            app.pax.ThetaDir = 'clockwise';
            hold(app.pax, 'on');
            if app.E_TotalCheckBox.Value
                hPt = polarplot(app.pax, deg2rad(cutAngle), cutData.total, '-r', 'LineWidth',2, 'DisplayName','E_{Total}');
                dt = datatip(hPt, 0,0); delete(dt);
                hPt.DataTipTemplate.DataTipRows(1) = dataTipTextRow(xStr, cutAngle, '%g\x00B0');
                hPt.DataTipTemplate.DataTipRows(2) = dataTipTextRow('Mag', cutData.total, '%.2g dBi');
            end
            if app.E_RHCPCheckBox.Value
                hPr = polarplot(app.pax, deg2rad(cutAngle), cutData.rhcp, '-', 'LineWidth',2, 'Color','#0072BD', 'DisplayName','E_{RHCP}');
                dt = datatip(hPr, 0,0); delete(dt);
                hPr.DataTipTemplate.DataTipRows(1) = dataTipTextRow(xStr, cutAngle, '%g\x00B0');
                hPr.DataTipTemplate.DataTipRows(2) = dataTipTextRow('Mag', cutData.rhcp, '%.2g dBi');
            end
            if app.E_LHCPCheckBox.Value
                hPl = polarplot(app.pax, deg2rad(cutAngle), cutData.lhcp, '-', 'LineWidth',2, 'Color','#77AC30', 'DisplayName','E_{LHCP}');
                dt = datatip(hPl, 0,0); delete(dt);
                hPl.DataTipTemplate.DataTipRows(1) = dataTipTextRow(xStr, cutAngle, '%g\x00B0');
                hPl.DataTipTemplate.DataTipRows(2) = dataTipTextRow('Mag', cutData.lhcp, '%.2g dBi');
            end
            hold(app.pax, 'off');
            rlim(app.pax, [cmin cmax]);
            rticks(app.pax, cmin:cstep:cmax);
            thetaticks(app.pax, 0:15:360);
            legend(app.pax, 'Location','northeastoutside');
            title(app.pax, cutLabel, 'Interpreter', 'tex');

            % --- Rectangular Cut ---
            ax5 = app.Axes_Rect;
            cla(ax5);
            hold(ax5, 'on');

            if app.E_TotalCheckBox.Value
                hRt = plot(ax5, cutAngle, cutData.total, '-r', 'LineWidth',2, 'DisplayName','E_{Total}');
                dt = datatip(hRt, 0,0); delete(dt);
                hRt.DataTipTemplate.DataTipRows(1) = dataTipTextRow(xStr, cutAngle, '%g\x00B0');
                hRt.DataTipTemplate.DataTipRows(2) = dataTipTextRow('Mag', cutData.total, '%.2g dBi');
            end
            if app.E_RHCPCheckBox.Value
                hRr = plot(ax5, cutAngle, cutData.rhcp, '-', 'LineWidth',2, 'Color','#0072BD', 'DisplayName','E_{RHCP}');
                dt = datatip(hRr, 0,0); delete(dt);
                hRr.DataTipTemplate.DataTipRows(1) = dataTipTextRow(xStr, cutAngle, '%g\x00B0');
                hRr.DataTipTemplate.DataTipRows(2) = dataTipTextRow('Mag', cutData.rhcp, '%.2g dBi');
            end
            if app.E_LHCPCheckBox.Value
                hRl = plot(ax5, cutAngle, cutData.lhcp, '-', 'LineWidth',2, 'Color','#77AC30', 'DisplayName','E_{LHCP}');
                dt = datatip(hRl, 0,0); delete(dt);
                hRl.DataTipTemplate.DataTipRows(1) = dataTipTextRow(xStr, cutAngle, '%g\x00B0');
                hRl.DataTipTemplate.DataTipRows(2) = dataTipTextRow('Mag', cutData.lhcp, '%.2g dBi');
            end
            hold(ax5, 'off');
            grid(ax5, 'on');
            set(ax5, 'YLim',[cmin cmax], 'XLim',[0 360], 'XTick',0:30:360);
            xticks(ax5, 0:30:360);
            ylabel(ax5, 'Gain (dBi)');
            xlabel(ax5, xLbl);
            title(ax5, cutLabel, 'Interpreter', 'tex');
            legend(ax5, 'Location','best');

            % --- Filled Polar Cut (Balanis-style gradient-filled lobes) ---
            % Pass compVal so the filled polar follows the component dropdown
            app.updateFilledPolarPlot(cutAngle, cutData, cutLabel, cmin, cmax, compVal);

            % --- Re-apply HPBW overlay if state button is ON (and not being cleared) ---
            if app.HPBWButton.Value && ~app.hpbwIsUpdating
                app.applyHPBWOverlay();
            end
        end

        % Extract a phi-cut or theta-cut robustly utilizing native GridCache matrix geometries
        function [cutAngle, cutData, cutLabel] = extractCut(app)
            if isempty(app.cachedGrid); app.buildGridCache(); end
            g = app.cachedGrid;
            
            cutType = app.DropDown_CutType.Value;
            cutVal  = app.Input_Cut_Value.Value;

            if strcmp(cutType, 'Phi Cut')
                % phi cut traces natively along rows locked to a nearest Theta value
                [~, iTh] = min(abs(g.thVec - cutVal));
                trueTh = g.thVec(iTh);
                cutAngle = g.phVec(:);
                
                cutData.total = g.G_tot(iTh, :)';
                cutData.rhcp  = g.G_rhcp(iTh, :)';
                cutData.lhcp  = g.G_lhcp(iTh, :)';
                cutData.pol   = g.G_pol(iTh, :)';
                
                cutLabel = ['Phi Cut (\theta = ' num2str(trueTh, '%g') '^\circ)']; 

            else % Theta Cut
                phMatch = mod(cutVal, 360);
                phiOpposite = mod(phMatch + 180, 360);
                
                [~, iPhFwd] = min(abs(g.phVec - phMatch));
                [~, iPhBk]  = min(abs(g.phVec - phiOpposite));
                
                % To make a full 360 sweep we map front and mirrored backing cuts symmetrically
                th_Fwd = g.thVec(:);
                th_Bk  = flipud(g.thVec(:));
                
                cutAngle = [th_Fwd; 360 - th_Bk];
                
                cutData.total = [g.G_tot(:, iPhFwd); flipud(g.G_tot(:, iPhBk))];
                cutData.rhcp  = [g.G_rhcp(:, iPhFwd); flipud(g.G_rhcp(:, iPhBk))];
                cutData.lhcp  = [g.G_lhcp(:, iPhFwd); flipud(g.G_lhcp(:, iPhBk))];
                cutData.pol   = [g.G_pol(:, iPhFwd); flipud(g.G_pol(:, iPhBk))];
                
                truePh = g.phVec(iPhFwd);
                cutLabel = ['Theta Cut (\phi_{Front} = ' num2str(truePh, '%g') '^\circ)'];
            end
        end

        % ════════════════════════════════════════════════════════════════
        %  BEAM METRICS — HPBW, SLL, FNBW, FBR
        %  Uses CIRCULAR WRAPPING: the data array is tripled (prepend + append
        %  copies shifted by ±360°) so that the peak can always find crossings
        %  on both sides, even when the peak is at the first or last element
        %  (e.g., boresight toward +Z at θ=0°).
        % ════════════════════════════════════════════════════════════════
        function result = computeBeamMetrics(~, cutAngle, gainData)
            result = struct();
            N = numel(gainData);
            
            % --- 1) Peak gain and angle (on original data) ---
            [peakGain, peakIdx] = max(gainData);
            peakAngle = cutAngle(peakIdx);
            result.peakGain  = peakGain;
            result.peakAngle = peakAngle;
            result.peakIdx   = peakIdx;
            
            % --- 2) Half-power threshold ---
            halfPowerLevel = peakGain - 3;
            result.halfPowerLevel = halfPowerLevel;
            
            % --- 3) CIRCULAR WRAPPING: extend data to handle edge peaks ---
            % Prepend a copy shifted by -360° and append a copy shifted by +360°
            extAngle = [cutAngle(:) - 360; cutAngle(:); cutAngle(:) + 360];
            extGain  = [gainData(:); gainData(:); gainData(:)];
            extPeakIdx = peakIdx + N;  % Peak index in the middle copy
            
            % --- 4) Find ALL -3 dB crossings in extended array ---
            shifted = extGain - halfPowerLevel;
            Nex = numel(extGain);
            crossAngles = [];
            for k = 1:Nex-1
                if shifted(k) * shifted(k+1) < 0
                    frac = abs(shifted(k)) / (abs(shifted(k)) + abs(shifted(k+1)));
                    crossAngles(end+1) = extAngle(k) + frac * (extAngle(k+1) - extAngle(k)); %#ok<AGROW>
                end
            end
            
            % --- 5) Pick nearest crossings to extended peak ---
            extPeakAngle = extAngle(extPeakIdx);
            leftAngle  = NaN;
            rightAngle = NaN;
            if ~isempty(crossAngles)
                leftCandidates = crossAngles(crossAngles < extPeakAngle);
                if ~isempty(leftCandidates)
                    leftAngle = max(leftCandidates);
                end
                rightCandidates = crossAngles(crossAngles > extPeakAngle);
                if ~isempty(rightCandidates)
                    rightAngle = min(rightCandidates);
                end
            end
            
            % --- 6) HPBW (map back to [0, 360] range for display) ---
            if ~isnan(leftAngle) && ~isnan(rightAngle)
                result.hpbw = rightAngle - leftAngle;
                % Map crossing angles back into the original [0, 360] domain
                result.leftAngle  = mod(leftAngle, 360);
                result.rightAngle = mod(rightAngle, 360);
            else
                result.hpbw = NaN;
                result.leftAngle  = NaN;
                result.rightAngle = NaN;
            end
            
            % --- 7) Front-to-Back Ratio ---
            backAngle = mod(peakAngle + 180, 360);
            [~, backIdx] = min(abs(cutAngle - backAngle));
            result.fbr = peakGain - gainData(backIdx);
            
            % --- 8) Side Lobe Level (SLL) ---
            result.sll = NaN;
            result.sllAngle = NaN;
            if N > 4
                dg = diff(gainData);
                localMaxIdx = find(dg(1:end-1) > 0 & dg(2:end) <= 0) + 1;
                localMaxIdx(abs(localMaxIdx - peakIdx) <= 2) = [];
                if ~isempty(localMaxIdx)
                    [sideMax, bestSide] = max(gainData(localMaxIdx));
                    result.sll = peakGain - sideMax;
                    result.sllAngle = cutAngle(localMaxIdx(bestSide));
                end
            end
            
            % --- 9) First Null Beamwidth (FNBW) ---
            result.fnbw = NaN;
            leftNull = NaN; rightNull = NaN;
            for k = peakIdx:-1:2
                if gainData(k-1) > gainData(k)
                    leftNull = cutAngle(k);
                    break;
                end
            end
            for k = peakIdx:N-1
                if gainData(k+1) > gainData(k)
                    rightNull = cutAngle(k);
                    break;
                end
            end
            if ~isnan(leftNull) && ~isnan(rightNull)
                result.fnbw = rightNull - leftNull;
            end
            result.leftNull  = leftNull;
            result.rightNull = rightNull;
        end

        % ════════════════════════════════════════════════════════════════
        %  HPBW STATE BUTTON CALLBACK — Toggle beam metrics overlay
        %  When ON:  Computes beam metrics, updates label, draws overlays
        %  When OFF: Clears overlays by re-rendering the cut plots
        % ════════════════════════════════════════════════════════════════
        function hpbwButtonPushed(app, event)
            if isempty(app.results); app.HPBWButton.Value = false; return; end
            
            if app.HPBWButton.Value  % Button toggled ON
                [cutAngle, cutData, ~] = app.extractCut();
                app.hpbwResult = app.computeBeamMetrics(cutAngle, cutData.total);
                app.applyHPBWOverlay();
            else  % Button toggled OFF
                app.hpbwResult = [];
                app.Label_HPBW.Text = '';
                % Guard flag prevents applyHPBWOverlay from firing during re-render
                app.hpbwIsUpdating = true;
                % Force full re-render of rect+polar to clear all overlay objects
                cla(app.Axes_Rect); cla(app.pax, 'reset');
                app.updateCutPlots();
                app.hpbwIsUpdating = false;
            end
        end

        % ════════════════════════════════════════════════════════════════
        %  APPLY HPBW OVERLAY — Draws beam metrics on existing cut plots
        %  Called by hpbwButtonPushed and updateCutPlots (when state is ON)
        % ════════════════════════════════════════════════════════════════
        function applyHPBWOverlay(app)
            if isempty(app.hpbwResult); return; end
            
            % Re-compute metrics for the current cut (in case cut changed)
            [cutAngle, cutData, ~] = app.extractCut();
            bm = app.computeBeamMetrics(cutAngle, cutData.total);
            app.hpbwResult = bm;
            
            cmin = app.Input_Plot_Cmin.Value;
            
            % --- Update HPBW Label with comprehensive beam metrics ---
            parts = {};
            if ~isnan(bm.hpbw)
                parts{end+1} = sprintf('HPBW: %.1f°', bm.hpbw);
            else
                parts{end+1} = 'HPBW: N/A';
            end
            parts{end+1} = sprintf('Peak: %.1f dBi @ %.0f°', bm.peakGain, bm.peakAngle);
            parts{end+1} = sprintf('FBR: %.1f dB', bm.fbr);
            if ~isnan(bm.sll)
                parts{end+1} = sprintf('SLL: -%.1f dB @ %.0f°', bm.sll, bm.sllAngle);
            end
            if ~isnan(bm.fnbw)
                parts{end+1} = sprintf('FNBW: %.1f°', bm.fnbw);
            end
            app.Label_HPBW.Text = strjoin(parts, newline);
            
            % --- Overlay on Rectangular Cut (ax5) ---
            ax5 = app.Axes_Rect;
            hold(ax5, 'on');
            
            % Peak marker (diamond)
            plot(ax5, bm.peakAngle, bm.peakGain, 'kd', 'MarkerSize', 10, ...
                'MarkerFaceColor', 'y', 'LineWidth', 1.5, 'HandleVisibility', 'off');
            
            if ~isnan(bm.hpbw)
                % Check if angles wrap around 360° (leftAngle > rightAngle after mod)
                isWrapped = bm.leftAngle > bm.rightAngle;
                
                if isWrapped
                    % Wrapping case: HPBW region is [leftAngle, 360] + [0, rightAngle]
                    inRegion = (cutAngle >= bm.leftAngle) | (cutAngle <= bm.rightAngle);
                else
                    % Normal case: HPBW region is [leftAngle, rightAngle]
                    inRegion = (cutAngle >= bm.leftAngle) & (cutAngle <= bm.rightAngle);
                end
                
                regionAngles = cutAngle(inRegion);
                regionGain   = cutData.total(inRegion);
                
                % For non-wrapping: draw a single contiguous shaded patch
                if ~isWrapped && numel(regionAngles) > 0
                    % Horizontal dashed line at -3 dB level
                    plot(ax5, [bm.leftAngle bm.rightAngle], ...
                        [bm.halfPowerLevel bm.halfPowerLevel], ...
                        '--k', 'LineWidth', 1.5, 'HandleVisibility', 'off');
                    
                    patchX = [bm.leftAngle; regionAngles(:); bm.rightAngle; bm.leftAngle];
                    patchY = [bm.halfPowerLevel; regionGain(:); bm.halfPowerLevel; bm.halfPowerLevel];
                    patch(ax5, patchX, patchY, [1 1 0], 'FaceAlpha', 0.25, 'EdgeColor', 'none', ...
                        'HandleVisibility', 'off');
                end
                
                % Vertical dashed lines at -3 dB crossing angles
                plot(ax5, [bm.leftAngle bm.leftAngle], [cmin bm.halfPowerLevel], ...
                    ':k', 'LineWidth', 1, 'HandleVisibility', 'off');
                plot(ax5, [bm.rightAngle bm.rightAngle], [cmin bm.halfPowerLevel], ...
                    ':k', 'LineWidth', 1, 'HandleVisibility', 'off');
                
                % HPBW annotation text centered in the highlighted region
                midAngle = (bm.leftAngle + bm.rightAngle) / 2;
                text(ax5, midAngle, bm.halfPowerLevel + 1, ...
                    sprintf('HPBW = %.1f°', bm.hpbw), ...
                    'HorizontalAlignment', 'center', 'FontWeight', 'bold', ...
                    'FontSize', 10, 'Color', [0.2 0.2 0.2], 'BackgroundColor', [1 1 0.8 0.8]);
            end
            hold(ax5, 'off');
            
            % --- Overlay on Polar Cut (pax) using thetaregion ---
            hold(app.pax, 'on');
            
            % Peak marker
            polarplot(app.pax, deg2rad(bm.peakAngle), bm.peakGain, 'kd', ...
                'MarkerSize', 10, 'MarkerFaceColor', 'y', 'LineWidth', 1.5, ...
                'HandleVisibility', 'off');
            
            if ~isnan(bm.hpbw)
                % thetaregion highlights the HPBW angular span on the polar axes
                % When wrapped (leftAngle > rightAngle), compute the end angle
                % as leftAngle + hpbw to ensure the short arc is drawn
                trLeft = deg2rad(bm.leftAngle);
                if bm.leftAngle > bm.rightAngle
                    % Wrapping case: extend rightAngle past 360° so MATLAB
                    % draws the short arc through 0° (e.g. 350° → 370°)
                    trRight = deg2rad(bm.leftAngle + bm.hpbw);
                else
                    trRight = deg2rad(bm.rightAngle);
                end
                try
                    tr = thetaregion(app.pax, trLeft, trRight);
                    tr.FaceColor = [1 1 0];
                    tr.FaceAlpha = 0.15;
                    tr.HandleVisibility = 'off';
                catch
                    % Fallback for MATLAB versions without thetaregion
                    arcAngles = linspace(trLeft, trRight, 100);
                    polarplot(app.pax, arcAngles, bm.halfPowerLevel * ones(size(arcAngles)), ...
                        '--k', 'LineWidth', 1.5, 'HandleVisibility', 'off');
                end
                
                % Radial dashed lines at crossing angles
                polarplot(app.pax, [deg2rad(bm.leftAngle) deg2rad(bm.leftAngle)], ...
                    [cmin bm.halfPowerLevel], ':k', 'LineWidth', 1, 'HandleVisibility', 'off');
                polarplot(app.pax, [deg2rad(bm.rightAngle) deg2rad(bm.rightAngle)], ...
                    [cmin bm.halfPowerLevel], ':k', 'LineWidth', 1, 'HandleVisibility', 'off');
            end
            hold(app.pax, 'off');
        end

        % ════════════════════════════════════════════════════════════════
        %  DIRECTIVITY COMPUTATION
        %  Numerical integration: D = 4*pi * Umax / Prad
        %  where Prad = integral of U(theta,phi)*sin(theta) over full sphere
        % ════════════════════════════════════════════════════════════════
        function D_dBi = computeDirectivity(app)
            if isempty(app.results); D_dBi = NaN; return; end
            r = app.results;
            G_lin = 10.^(r.G_total_dB / 10);  % Convert gain to linear
            theta_rad = deg2rad(r.theta);
            dTh = deg2rad(r.header.theta_inc);
            dPh = deg2rad(r.header.phi_inc);
            % Numerical integration using trapezoidal-style solid angle weights
            weights = sin(theta_rad) * dTh * dPh;
            Prad = sum(G_lin .* weights);
            Umax = max(G_lin);
            if Prad > 0
                D_lin = 4 * pi * Umax / Prad;
                D_dBi = 10 * log10(D_lin);
            else
                D_dBi = NaN;
            end
        end

        % ════════════════════════════════════════════════════════════════
        %  FILLED POLAR CUT PLOT (Balanis-style)
        %  Uses pcolor surface for FULL DataTip coverage across the entire
        %  filled area (not just the boundary). Also ~100x faster than the
        %  patch loop approach since it's a single graphics call.
        %
        %  Orientation: 0° at TOP, clockwise (X=R*sind, Y=R*cosd)
        %  Component-aware: compVal selects which gain trace to fill
        % ════════════════════════════════════════════════════════════════
        function updateFilledPolarPlot(app, cutAngle, cutData, cutLabel, cmin, cmax, compVal)
            ax6 = app.Axes_FilledPolar;
            cla(ax6);
            
            % Select gain trace based on component dropdown
            switch compVal
                case 'RHCP Gain';       gainTrace = cutData.rhcp;  cLabel = 'RHCP Gain (dBi)';
                case 'LHCP  Gain';      gainTrace = cutData.lhcp;  cLabel = 'LHCP Gain (dBi)';
                case 'Polarized Gain';  gainTrace = cutData.pol;   cLabel = 'Polarized Gain (dBi)';
                otherwise;              gainTrace = cutData.total; cLabel = 'Total Gain (dBi)';
            end
            
            % Radial scale: shift so cmin maps to R=0 (center)
            R = max(gainTrace - cmin, 0);
            maxR = cmax - cmin;
            if maxR <= 0; return; end
            
            % --- Adaptive radial mesh: each row stretches exactly to R(angle) ---
            % This eliminates boundary spikes caused by the uniform-grid NaN mask
            nRadial = 60;
            rNorm = linspace(0, 1, nRadial);  % normalized 0..1
            nAngles = numel(cutAngle);
            
            % Per-angle radial extent: RR(i,:) goes from 0 to R(i)
            RR = R(:) * rNorm;                      % [nAngles x nRadial]
            AA = repmat(cutAngle(:), 1, nRadial);   % angle at each grid point
            
            % Cartesian: 0° at TOP, clockwise
            XX = RR .* sind(AA);
            YY = RR .* cosd(AA);
            
            % Gain is constant along radius for each angle (1D cut)
            GG = repmat(gainTrace(:), 1, nRadial);
            
            hold(ax6, 'on');
            
            % Single pcolor call — fast + boundary-conforming + full DataTips
            hSurf = pcolor(ax6, XX, YY, GG);
            shading(ax6, 'flat');
            hSurf.EdgeColor = 'none';
            
            % Configure DataTipTemplate on the pcolor surface
            dt = datatip(hSurf, XX(1,1), YY(1,1)); delete(dt);
            if strcmp(app.DropDown_CutType.Value, 'Phi Cut')
                hSurf.DataTipTemplate.DataTipRows(1) = dataTipTextRow('\phi', AA, '%g°');
            else
                hSurf.DataTipTemplate.DataTipRows(1) = dataTipTextRow('\theta', AA, '%g°');
            end
            hSurf.DataTipTemplate.DataTipRows(2) = dataTipTextRow('Mag', GG, '%.2f dBi');
            
            % --- Outline: thin boundary ---
            Xb = R .* sind(cutAngle);
            Yb = R .* cosd(cutAngle);
            plot(ax6, [Xb; Xb(1)], [Yb; Yb(1)], '-k', 'LineWidth', 0.6, ...
                'HitTest', 'off', 'PickableParts', 'none');
            
            % --- Circular grid rings at regular dB intervals ---
            ang = linspace(0, 2*pi, 361);
            gridStep = app.Input_Plot_Cstep.Value;
            if gridStep <= 0; gridStep = 10; end
            for rVal = gridStep : gridStep : maxR
                plot(ax6, rVal*sin(ang), rVal*cos(ang), '-', ...
                    'Color', [0.7 0.7 0.7 0.5], 'LineWidth', 0.5, 'HitTest', 'off', 'PickableParts', 'none');
                dbVal = cmin + rVal;
                text(ax6, rVal*sind(15)+1, rVal*cosd(15)+1, sprintf('%g dB', dbVal), ...
                    'Color', [0.4 0.4 0.4], 'FontSize', 8, 'HitTest', 'off', 'PickableParts', 'none');
            end
            
            % --- Radial spoke lines every 30° (0° at top, clockwise) ---
            for p = 0:30:330
                plot(ax6, [0 maxR*sind(p)], [0 maxR*cosd(p)], '-', ...
                    'Color', [0.7 0.7 0.7 0.5], 'LineWidth', 0.5, 'HitTest', 'off', 'PickableParts', 'none');
                text(ax6, (maxR+3)*sind(p), (maxR+3)*cosd(p), [num2str(p) '^{\circ}'], ...
                    'HorizontalAlignment', 'center', 'FontSize', 9, 'FontWeight', 'bold', ...
                    'Color', [0.3 0.3 0.3], 'HitTest', 'off', 'PickableParts', 'none');
            end
            
            hold(ax6, 'off');
            
            colormap(ax6, jet(256));
            clim(ax6, [cmin cmax]);
            cb = colorbar(ax6); cb.Label.String = cLabel;
            
            paddedR = maxR * 1.2;
            axis(ax6, [-paddedR paddedR -paddedR paddedR]);
            axis(ax6, 'equal');
            axis(ax6, 'off');
            title(ax6, cutLabel, 'Interpreter', 'tex');
        end

        % Wrapper for UI callback events to re-render all plots
        function updatePlotsEvent(app, event)
            app.updatePlots();
        end

        % Wrapper for cut-only updates (checkboxes, cut value, cut type)
        function updateCutPlotsEvent(app, event)
            app.updateCutPlots();
        end
        
        % Helper: Add XYZ axes and translucent/cross planes to 3D plots
        % showNeg: if true, also draw negative (-X, -Y, -Z) axes
        function add_3d_axes(~, ax, Rmax, showNeg)
            if nargin < 4; showNeg = false; end
            hold(ax, 'on');
            r = Rmax;
            quiver3(ax, 0,0,0, r,0,0, 0, 'Color', 'r', 'LineWidth', 1.5, 'MaxHeadSize', 0.15, 'HitTest', 'off', 'PickableParts', 'none'); text(ax, 1.1*r,0,0, '+X (\phi=0°)', 'Color','r', 'FontSize', 13, 'FontWeight','bold', 'HitTest', 'off', 'PickableParts', 'none'); % +X
            quiver3(ax, 0,0,0, 0,r,0, 0, 'Color', 'g', 'LineWidth', 1.5, 'MaxHeadSize', 0.15, 'HitTest', 'off', 'PickableParts', 'none'); text(ax, 0,1.05*r,0, '+Y (\phi=90°)', 'Color','g', 'FontSize', 13, 'FontWeight','bold', 'HitTest', 'off', 'PickableParts', 'none'); % +Y
            quiver3(ax, 0,0,0, 0,0,r, 0, 'Color', 'b', 'LineWidth', 1.5, 'MaxHeadSize', 0.15, 'HitTest', 'off', 'PickableParts', 'none'); text(ax, 0,0,1.05*r, '+Z (\theta=0°)', 'Color','b', 'FontSize', 13, 'FontWeight','bold', 'HitTest', 'off', 'PickableParts', 'none'); % +Z
            
            % Negative axes (dashed, thinner) — controlled by checkbox
            if showNeg
                plot3(ax, [0, -r*1.0], [0, 0], [0, 0], 'r--', 'LineWidth', 1.3, 'HitTest', 'off', 'PickableParts', 'none'); text(ax, -1.1*r,0,0, '-X (\phi=180°)', 'Color','r', 'FontSize', 13, 'FontWeight','bold', 'HitTest', 'off', 'PickableParts', 'none');
                plot3(ax, [0, 0], [0, -r*1.0], [0, 0], 'g--', 'LineWidth', 1.3, 'HitTest', 'off', 'PickableParts', 'none'); text(ax, 0,-r*1.05,0, '-Y (\phi=270°)', 'Color','g', 'FontSize', 13, 'FontWeight','bold', 'HitTest', 'off', 'PickableParts', 'none');
                plot3(ax, [0, 0], [0, 0], [0, -r*1.0], 'b--', 'LineWidth', 1.3, 'HitTest', 'off', 'PickableParts', 'none'); text(ax, 0,0,-1.05*r, '-Z (\theta=180°)', 'Color','b', 'FontSize', 13, 'FontWeight','bold', 'HitTest', 'off', 'PickableParts', 'none');
            end

            % Draw XY, XZ, YZ plane circles mimicing patternCustom
            ang = linspace(0, 2*pi, 100);
            circZ = zeros(size(ang));
            circR = r * 0.95;
            plot3(ax, circR*cos(ang), circR*sin(ang), circZ, '-', 'Color', [0 0 1 0.4], 'LineWidth', 1, 'HitTest', 'off', 'PickableParts', 'none'); % XY (Blue)
            plot3(ax, circR*cos(ang), circZ, circR*sin(ang), '-', 'Color', [0 1 0 0.4], 'LineWidth', 1, 'HitTest', 'off', 'PickableParts', 'none'); % XZ (Green)
            plot3(ax, circZ, circR*cos(ang), circR*sin(ang), '-', 'Color', [1 0 0 0.4], 'LineWidth', 1, 'HitTest', 'off', 'PickableParts', 'none'); % YZ (Red)
            hold(ax, 'off');
        end

        % Coverage Type radio-button toggle
        function coverageTypeChanged(app, event)
            isCone = (event.NewValue == app.Button_Conical);
            enStr = 'off';
            if isCone; enStr = 'on'; end
            app.Spinner_coneTH.Enable  = enStr;
            app.Spinner_conePH.Enable  = enStr;
            app.Spinner_coneAng.Enable = enStr;
            app.Cone0Label.Enable      = enStr;
            app.ConeLabel.Enable       = enStr;
            app.CongAngleLabel.Enable  = enStr;
        end

        % Tab 1 Compute Coverage shortcut
        function computeCoverageT1ButtonPushed(app, event)
            if isempty(app.patData)
                uialert(app.UIFigure, 'Load a pattern file in Tab 1 first.', 'No Data');
                return;
            end
            % Copy data to Coverage state
            app.patData_cov = app.patData;
            app.Input_PatternField_3.Value = app.Input_PatternField.Value;
            
            % Jump to Tab 3
            app.TabGroup.SelectedTab = app.Tab3;
            
            % Trigger coverage processing
            app.processCovButtonPushed([]);
        end

        % Clear Coverage logic
        function clearCovButtonPushed(app, event)
            app.covResultsList = {};
            delete(app.Tree.Children);
            app.updateCoveragePlot();
            app.updateCoverageTable();
        end

        % Coverage Orientation logic
        function covOrientationChanged(app, event)
            val = event.Value;
            % '1. Forward (+X)', '2. Aft (-X)', '3. Starboard (+Y)', '4. Port (-Y)', '5. Overhead (+Z)', '6. Deck (-Z)', '7. Arbitrary Orientation'
            switch val
                case '2'; t=90;  p=0;
                case '3'; t=90;  p=180;
                case '4'; t=90;  p=90;
                case '5'; t=90;  p=270;
                case '6'; t=0;   p=0;
                case '7'; t=180; p=0;
                otherwise; return;
            end
            app.Spinner_coneTH.Value = t;
            app.Spinner_conePH.Value = p;
        end

        % Load button for Coverage tab
        function loadCovButtonPushed(app, event)
            [fnames, fpath, filterIndex] = uigetfile({
                '*.fz;*.uan;*.cut;*.out;*.ffs;*.ffd;*.ffe;*.csv;*.txt', 'Antenna Patterns (*.fz, *.uan, *.cut, *.out, *.ffs, *.ffd, *.ffe, *.csv, *.txt)';
                '*.dat;*.txt;*.csv;*.xlsx', 'Coverage Results (*.dat, *.txt, *.csv, *.xlsx)';
                '*.*', 'All Files (*.*)'
            }, 'Select Input Files', 'MultiSelect', 'on');
            if isequal(fnames,0); return; end
            if ischar(fnames); fnames = {fnames}; end
            
            d = uiprogressdlg(app.UIFigure, 'Title','Loading Data', 'Message','Please wait while the data is being loaded...', 'Indeterminate','on');
            try
                if filterIndex == 2
                    % --- IMPORT COVERAGE RESULTS ---
                    for fidx = 1:numel(fnames)
                        filePath = fullfile(fpath, fnames{fidx});
                        try
                            opts = detectImportOptions(filePath);
                            opts.VariableNamingRule = 'preserve';
                            T = readtable(filePath, opts);
                            colNames = T.Properties.VariableNames;
                            if numel(colNames) >= 2
                                thCol = T{:, 1};
                                if ~isnumeric(thCol); thCol = str2double(string(thCol)); end
                                for c = 2:numel(colNames)
                                    covName = colNames{c};
                                    covCol = T{:, c};
                                    if ~isnumeric(covCol)
                                        strArray = string(covCol);
                                        strArray = strrep(strArray, '%', '');
                                        covCol = str2double(strArray);
                                    end
                                    res = struct();
                                    validData = ~isnan(thCol(:)) & ~isnan(covCol(:));
                                    res.thresholds = thCol(validData);
                                    res.coverage_pct = covCol(validData);
                                    label = covName;
                                    if strncmpi(label, 'Var', 3) || isempty(label)
                                        [~,name,~] = fileparts(fnames{fidx});
                                        if numel(colNames) > 2; label = sprintf('%s (Col %d)', name, c); else; label = name; end
                                    end
                                    res.label = label;
                                    res.tableData = table(res.thresholds, res.coverage_pct, 'VariableNames', {'Threshold_dB', 'Coverage_pct'});
                                    idx = numel(app.covResultsList) + 1;
                                    app.covResultsList{idx} = res;
                                    node = uitreenode(app.Tree, 'Text', label, 'NodeData', idx);
                                    app.Tree.CheckedNodes = [app.Tree.CheckedNodes; node];
                                end
                            end
                        catch ME_file
                            uialert(app.UIFigure, sprintf('Failed to read %s:\n%s', fnames{fidx}, ME_file.message), 'Import Error');
                        end
                    end
                    app.updateCoveragePlot();
                    app.updateCoverageTable();
                else
                    % --- LOAD ANTENNA PATTERNS (Single or Aggregate) ---
                    app.patDataArray_cov = {};
                    for fidx = 1:numel(fnames)
                        app.filePath_raw = fullfile(fpath, fnames{fidx});
                        app.patDataArray_cov{end+1} = app.parsePatternFile();
                    end
                    app.patData_cov = app.patDataArray_cov{1}; % Fallback map
                    if numel(fnames) > 1
                        app.Input_PatternField_3.Value = sprintf('(%d) Multi-Pattern Beams Loaded', numel(fnames));
                    else
                        app.Input_PatternField_3.Value = fullfile(fpath, fnames{1});
                    end
                end
                close(d);
            catch ME
                try close(d); catch; end
                uialert(app.UIFigure, ME.message, 'Load Error');
            end
        end

        % Process button for Coverage tab
        function processCovButtonPushed(app, event)
            if isempty(app.patData_cov)
                uialert(app.UIFigure, 'Load an antenna pattern file first.', 'No Data');
                return;
            end
            try
                d = uiprogressdlg(app.UIFigure,'Title','Computing Coverage...','Indeterminate','on');
                result = app.computeCoverage();
                app.covResultsList{end+1} = result;
                idx = numel(app.covResultsList);

                % Add tree node
                node = uitreenode(app.Tree, 'Text', result.label, 'NodeData', idx);
                app.Tree.CheckedNodes = [app.Tree.CheckedNodes; node];

                close(d);
                app.updateCoveragePlot();
                app.updateCoverageTable();
            catch ME
                try close(d); catch; end
                uialert(app.UIFigure, sprintf('%s\n(%s line %d)', ME.message, ME.stack(1).name, ME.stack(1).line), 'Coverage Error');
            end
        end

        % Tree check-changed callback
        function covTreeCheckedChanged(app, event)
            app.updateCoveragePlot();
            app.updateCoverageTable();
        end

        % Tree double-click callback to rename node
        function covTreeDoubleClicked(app, event)
            node = app.Tree.SelectedNodes;
            if isempty(node); return; end
            idx = node.NodeData;
            if isempty(idx); return; end
            oldName = node.Text;
            newName = inputdlg('Enter new name for coverage run:', 'Rename', 1, {oldName});
            if ~isempty(newName) && ~isempty(newName{1})
                node.Text = newName{1};
                app.covResultsList{idx}.label = newName{1};
                app.updateCoveragePlot();
                app.updateCoverageTable();
            end
        end

        % Update coverage plot for checked nodes
        function updateCoveragePlot(app)
            cla(app.UIAxes);
            hold(app.UIAxes, 'on');
            checked = app.Tree.CheckedNodes;
            legends = {};
            colors = lines(max(numel(app.covResultsList),7));
            for k = 1:numel(checked)
                nd = checked(k);
                idx = nd.NodeData;
                if isempty(idx) || ~isnumeric(idx); continue; end
                res = app.covResultsList{idx};
                plot(app.UIAxes, res.thresholds, res.coverage_pct, ...
                    '-', 'LineWidth', 1.5, 'Color', colors(mod(idx-1,size(colors,1))+1,:), ...
                    'MarkerSize', 4);
                legends{end+1} = res.label; %#ok<AGROW>
            end
            hold(app.UIAxes, 'off');
            xlabel(app.UIAxes, 'Threshold (dB)');
            ylabel(app.UIAxes, 'Coverage (%)');
            title(app.UIAxes, 'Coverage vs Threshold');
            if ~isempty(legends)
                legend(app.UIAxes, legends, 'Interpreter','none', 'Location','best');
            end
            ylim(app.UIAxes, [0 100]);
            grid(app.UIAxes, 'on');
        end

        % Update coverage table for checked nodes
        function updateCoverageTable(app)
            checked = app.Tree.CheckedNodes;
            if isempty(checked)
                app.UITable.Data = [];
                app.UITable.ColumnName = {};
                return;
            end
            % Collect valid indices and union of thresholds
            validIdx = [];
            allTh = [];
            for k = 1:numel(checked)
                idx = checked(k).NodeData;
                if isempty(idx) || ~isnumeric(idx); continue; end
                validIdx(end+1) = idx; %#ok<AGROW>
                allTh = union(allTh, app.covResultsList{idx}.thresholds);
            end
            if isempty(validIdx)
                app.UITable.Data = []; app.UITable.ColumnName = {}; return;
            end
            % Pre-allocate output matrix
            nRows = numel(allTh);
            nCols = numel(validIdx);
            combined = zeros(nRows, 1 + nCols);
            combined(:,1) = allTh(:);
            colNames = cell(1, 1 + nCols);
            colNames{1} = 'Threshold_dB';
            for k = 1:nCols
                res = app.covResultsList{validIdx(k)};
                combined(:, 1+k) = interp1(res.thresholds, res.coverage_pct, allTh, 'linear', NaN);
                colNames{1+k} = res.label;
            end
            app.UITable.Data = combined;
            app.UITable.ColumnName = colNames;
        end

        % Export coverage results
        function exportCovButtonPushed(app, event)
            checked = app.Tree.CheckedNodes;
            if isempty(checked)
                uialert(app.UIFigure, 'No coverage results checked for export.', 'Nothing to Export');
                return;
            end
            [fname,fpath] = uiputfile({'*.xlsx';'*.csv';'*.txt';'*.dat'}, 'Export Coverage Results');
            if isequal(fname,0); return; end
            outPath = fullfile(fpath, fname);
            T = array2table(app.UITable.Data, 'VariableNames', ...
                matlab.lang.makeValidName(app.UITable.ColumnName));
            
            [~,~,ext] = fileparts(fname);
            if strcmpi(ext, '.txt')
                writetable(T, outPath, 'Delimiter', '\t');
            elseif strcmpi(ext, '.dat')
                writetable(T, outPath, 'Delimiter', ' ');
            else
                writetable(T, outPath);
            end
            uialert(app.UIFigure, sprintf('Exported to %s', outPath), 'Export Complete', 'Icon','success');
        end



        % ════════════════════════════════════════════════════════════════
        %  TAB 4: COMBINE PATTERNS (ARRAY SYNTHESIS)
        % ════════════════════════════════════════════════════════════════

        function loadArrayButtonPushed(app, event)
            [fnames, fpath] = uigetfile({
                '*.fz;*.uan;*.cut;*.out;*.ffs;*.ffd;*.ffe;*.csv;*.txt', 'Antenna Patterns (*.fz, *.uan, *.cut, *.out, *.ffs, *.ffd, *.ffe, *.csv, *.txt)';
                '*.*', 'All Files (*.*)'
            }, 'Select Pattern for Array Synthesis', 'MultiSelect', 'on');
            if isequal(fnames,0); return; end
            if ischar(fnames); fnames = {fnames}; end
            
            d = uiprogressdlg(app.UIFigure, 'Title','Loading Data', 'Message','Loading patterns for array...');
            try
                for k = 1:numel(fnames)
                    app.filePath_raw = fullfile(fpath, fnames{k});
                    patData = app.parsePatternFile();
                    % Ensure we have phases to synthesize!
                    if patData.isGainOnly
                        uialert(app.UIFigure, sprintf('File "%s" contains only magnitudes (no phase). Array synthesis requires Complex E-fields or Explicit Phase. Skipping.', fnames{k}), 'Missing Phase Data', 'Icon', 'warning');
                        continue;
                    end
                    app.arrayBeams{end+1} = struct('patData', patData, 'mag_W', 1.0, 'phase_deg', 0.0, 'fileName', fnames{k});
                end
                close(d);
                app.updateArrayTable();
            catch ME
                try close(d); catch; end
                uialert(app.UIFigure, sprintf('Error loading array components:\n%s', ME.message), 'Error');
            end
        end

        function clearArrayButtonPushed(app, event)
            app.arrayBeams = {};
            app.updateArrayTable();
            cla(app.Axes_Array3D);
        end

        function updateArrayTable(app)
            % Regenerate table data
            if isempty(app.arrayBeams)
                app.Table_ArraySetup.Data = {};
                return;
            end
            tData = cell(numel(app.arrayBeams), 3);
            for k = 1:numel(app.arrayBeams)
                tData{k, 1} = app.arrayBeams{k}.fileName;
                tData{k, 2} = app.arrayBeams{k}.mag_W;
                tData{k, 3} = app.arrayBeams{k}.phase_deg;
            end
            app.Table_ArraySetup.Data = tData;
        end

        function arrayTableEdited(app, event)
            r = event.Indices(1);
            c = event.Indices(2);
            newVal = event.NewData;
            if c == 2
                app.arrayBeams{r}.mag_W = max(0, newVal); % Power can't be negative
            elseif c == 3
                app.arrayBeams{r}.phase_deg = mod(newVal, 360);
            end
            app.updateArrayTable(); % Refresh formatting
        end

        function computeArrayButtonPushed(app, event)
            if isempty(app.arrayBeams)
                uialert(app.UIFigure, 'No beams loaded to synthesize.', 'Empty Array');
                return;
            end
            
            d = uiprogressdlg(app.UIFigure, 'Title','Synthesizing Array', 'Message','Computing phased combinations...');
            try
                % Use element 1 as master grid
                basePat = app.arrayBeams{1}.patData;
                theta = basePat.theta;
                phi = basePat.phi;
                
                % Initialize Array E-Fields
                E_th_arr = zeros(size(theta)) + 1j * zeros(size(theta));
                E_ph_arr = zeros(size(phi))   + 1j * zeros(size(phi));
                
                TotalIncidentW = 0;
                
                for k = 1:numel(app.arrayBeams)
                    bm = app.arrayBeams{k};
                    pat = bm.patData;
                    
                    if numel(pat.theta) ~= numel(theta)
                        error('Grid size mismatch in element %d (%s).', k, bm.fileName);
                    end
                    
                    % E-field components from Phase + Gain map
                    Emag_th = 10.^(pat.G_theta_dB / 20);
                    Emag_ph = 10.^(pat.G_phi_dB / 20);
                    
                    shiftPhase = deg2rad(bm.phase_deg);
                    weightMag  = sqrt(bm.mag_W);
                    
                    % Complex E component summing
                    E_th_arr = E_th_arr + (Emag_th .* exp(1j * deg2rad(pat.phase_E_theta))) .* weightMag .* exp(1j * shiftPhase);
                    E_ph_arr = E_ph_arr + (Emag_ph .* exp(1j * deg2rad(pat.phase_E_phi)))   .* weightMag .* exp(1j * shiftPhase);
                    
                    TotalIncidentW = TotalIncidentW + bm.mag_W;
                end
                
                if TotalIncidentW == 0; TotalIncidentW = 1; end % Fallback
                
                P_th = abs(E_th_arr).^2;
                P_ph = abs(E_ph_arr).^2;
                G_tot_lin = (P_th + P_ph) / TotalIncidentW;
                
                % Convert array to standard patData structure
                arrayPat = basePat;
                arrayPat.G_theta_dB = 20 * log10(abs(E_th_arr) / sqrt(TotalIncidentW));
                arrayPat.G_phi_dB   = 20 * log10(abs(E_ph_arr) / sqrt(TotalIncidentW));
                arrayPat.phase_E_theta = rad2deg(angle(E_th_arr));
                arrayPat.phase_E_phi   = rad2deg(angle(E_ph_arr));
                
                % Apply Array to the Coverage Module directly so users can run Aggregate / Base Coverage on the Array!
                app.patDataArray_cov = {arrayPat};
                app.Input_PatternField_3.Value = 'Synthesized Array Component';
                
                % Plot Array 3D natively
                ax = app.Axes_Array3D;
                cla(ax);
                
                G_dB_viz = 10 * log10(G_tot_lin);
                
                % Convert to Cartesian unit scale using max gain
                [gPHI, gTHETA] = meshgrid(unique(phi), unique(theta));
                [~, sortIdx] = sortrows([theta, phi], [2, 1]);
                nTh = numel(unique(theta));
                nPh = numel(unique(phi));
                
                if (nTh * nPh == numel(theta))
                    G_grid = reshape(G_tot_lin(sortIdx), nTh, nPh);
                    gTH_rad = deg2rad(gTHETA); gPH_rad = deg2rad(gPHI);
                    Xs = G_grid .* sin(gTH_rad) .* cos(gPH_rad);
                    Ys = G_grid .* sin(gTH_rad) .* sin(gPH_rad);
                    Zs = G_grid .* cos(gTH_rad);
                    
                    surf(ax, Xs, Ys, Zs, 10*log10(G_grid), 'EdgeColor', 'none', 'FaceAlpha', 0.95);
                    cb = colorbar(ax);
                    cb.Label.String = 'Directivity (dBi)';
                    axis(ax, 'equal'); view(ax, 3);
                    title(ax, 'Synthesized Array 3D Directivity');
                    xlabel(ax, 'X'); ylabel(ax, 'Y'); zlabel(ax, 'Z');
                    grid(ax, 'on');
                else
                    scatter3(ax, G_tot_lin.*sind(theta).*cosd(phi), ...
                                 G_tot_lin.*sind(theta).*sind(phi), ...
                                 G_tot_lin.*cosd(theta), 10, G_dB_viz, 'filled');
                    colorbar(ax); axis(ax, 'equal'); view(ax, 3);
                    title(ax, 'Synthesized Array Point Cloud');
                end
                
                close(d);
                uialert(app.UIFigure, 'Array synthesis complete! The combined pattern has also been loaded into Tab 3 for Coverage Analysis!', 'Success', 'Icon','success');
            catch ME
                try close(d); catch; end
                uialert(app.UIFigure, sprintf('Synthesis Error:\n%s', ME.message), 'Error');
            end
        end

        % ── Tab 1 Export: Raw Input Data ──
        function exportInputButtonPushed(app, event)
            if isempty(app.patData)
                uialert(app.UIFigure, 'No input data loaded.', 'Nothing to Export');
                return;
            end
            [fname,fpath] = uiputfile({'*.csv';'*.xlsx'}, 'Export Input Data');
            if isequal(fname,0); return; end
            outPath = fullfile(fpath, fname);
            T = array2table(app.Table_DataIn.Data, ...
                'VariableNames', matlab.lang.makeValidName(app.Table_DataIn.ColumnName));
            writetable(T, outPath);
            uialert(app.UIFigure, sprintf('Exported to %s', outPath), 'Export Complete', 'Icon','success');
        end

        % ── Tab 1 Export: Processed Output Data ──
        function exportOutputButtonPushed(app, event)
            if isempty(app.results)
                uialert(app.UIFigure, 'No processed data available. Click Process first.', 'Nothing to Export');
                return;
            end
            [fname,fpath] = uiputfile({'*.csv';'*.xlsx'}, 'Export Output Data');
            if isequal(fname,0); return; end
            outPath = fullfile(fpath, fname);
            writetable(app.results.table, outPath);
            uialert(app.UIFigure, sprintf('Exported to %s', outPath), 'Export Complete', 'Icon','success');
        end

        % ── Tab 1 Export: Current Cut Data ──
        function exportCutButtonPushed(app, event)
            if isempty(app.results)
                uialert(app.UIFigure, 'No processed data available. Click Process first.', 'Nothing to Export');
                return;
            end
            try
                [cutAngle, cutData, cutLabel] = app.extractCut();
                [fname,fpath] = uiputfile({'*.csv';'*.xlsx'}, 'Export Cut Data');
                if isequal(fname,0); return; end
                outPath = fullfile(fpath, fname);
                T = table(cutAngle(:), cutData.total(:), cutData.rhcp(:), cutData.lhcp(:), ...
                    'VariableNames', {'Angle_deg','G_Total_dB','E_RHCP_dB','E_LHCP_dB'});
                writetable(T, outPath);
                uialert(app.UIFigure, sprintf('Exported %s cut to %s', cutLabel, outPath), 'Export Complete', 'Icon','success');
            catch ME
                uialert(app.UIFigure, ME.message, 'Export Error');
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            colormap(app.UIFigure, 'jet');
            app.UIFigure.Position = [100 100 1161 750];
            app.UIFigure.Name = 'Antenna Pattern Analyzer';
            app.UIFigure.WindowState = 'maximized';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {'1x'};
            app.GridLayout.RowHeight = {'1x'};

            % Create TabGroup
            app.TabGroup = uitabgroup(app.GridLayout);
            app.TabGroup.Layout.Row = 1;
            app.TabGroup.Layout.Column = 1;

            % Create Tab1
            app.Tab1 = uitab(app.TabGroup);
            app.Tab1.Title = 'Single Pattern';

            % Create Tab1_Grid
            app.Tab1_Grid = uigridlayout(app.Tab1);
            app.Tab1_Grid.ColumnWidth = {'1x', '1x', '0.3x'};
            app.Tab1_Grid.RowHeight = {'fit', '1.5x', 'fit', '1x'};

            % Create Tab1_Panel1
            app.Tab1_Panel1 = uipanel(app.Tab1_Grid);
            app.Tab1_Panel1.Title = 'Inputs & Parameters';
            app.Tab1_Panel1.Layout.Row = 1;
            app.Tab1_Panel1.Layout.Column = [1 3];

            % Create T1P1_Grid
            app.T1P1_Grid = uigridlayout(app.Tab1_Panel1);
            app.T1P1_Grid.ColumnWidth = {'1x', '1x', 'fit', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.T1P1_Grid.RowHeight = {'1x', '1x', '1x', '1x'};

            % Create FormatLabel
            app.FormatLabel = uilabel(app.T1P1_Grid);
            app.FormatLabel.HorizontalAlignment = 'right';
            app.FormatLabel.Layout.Row = 1;
            app.FormatLabel.Layout.Column = 1;
            app.FormatLabel.Text = 'Format:';

            % Create DropDown_Format
            app.DropDown_Format = uidropdown(app.T1P1_Grid);
            app.DropDown_Format.Items = {'Eθ, Eφ [mag_dB,phase°]', 'Eθ, Eφ [Re,Im]', 'Erh, Elh [mag_dB,phase°]', 'Erh, Elh [Re,Im]', 'Gain Pattern'};
            app.DropDown_Format.ItemsData = {'1', '2', '3', '4', '5'};
            app.DropDown_Format.Layout.Row = 1;
            app.DropDown_Format.Layout.Column = 2;
            app.DropDown_Format.Value = '1';

            % Create InputPatternLabel
            app.InputPatternLabel = uilabel(app.T1P1_Grid);
            app.InputPatternLabel.HorizontalAlignment = 'right';
            app.InputPatternLabel.Layout.Row = 1;
            app.InputPatternLabel.Layout.Column = 3;
            app.InputPatternLabel.Text = 'Input Pattern:';

            % Create Input_PatternField
            app.Input_PatternField = uieditfield(app.T1P1_Grid, 'text');
            app.Input_PatternField.Editable = 'off';
            app.Input_PatternField.Placeholder = '(No file loaded)';
            app.Input_PatternField.Layout.Row = 1;
            app.Input_PatternField.Layout.Column = [4 6];
            
            % Create Label_GainCol
            app.Label_GainCol = uilabel(app.T1P1_Grid);
            app.Label_GainCol.HorizontalAlignment = 'right';
            app.Label_GainCol.Layout.Row = 1;
            app.Label_GainCol.Layout.Column = 7;
            app.Label_GainCol.Text = 'Col:';
            app.Label_GainCol.Visible = 'off';

            % Create DropDown_GainCol
            app.DropDown_GainCol = uidropdown(app.T1P1_Grid);
            app.DropDown_GainCol.Items = {'Col 3'};
            app.DropDown_GainCol.ValueChangedFcn = createCallbackFcn(app, @gainColChangedEvent, true);
            app.DropDown_GainCol.Layout.Row = 1;
            app.DropDown_GainCol.Layout.Column = [8 10];
            app.DropDown_GainCol.Visible = 'off';

            % Create Button_Load
            app.Button_Load = uibutton(app.T1P1_Grid, 'push');
            app.Button_Load.ButtonPushedFcn = createCallbackFcn(app, @loadButtonPushed, true);
            app.Button_Load.Layout.Row = 1;
            app.Button_Load.Layout.Column = 11;
            app.Button_Load.Text = 'Load';

            % Create Button_Process
            app.Button_Process = uibutton(app.T1P1_Grid, 'push');
            app.Button_Process.ButtonPushedFcn = createCallbackFcn(app, @processButtonPushed, true);
            app.Button_Process.Layout.Row = 1;
            app.Button_Process.Layout.Column = 12;
            app.Button_Process.Text = 'Process';

            % Create Input_Label
            app.Input_Label = uilabel(app.T1P1_Grid);
            app.Input_Label.Layout.Row = 2;
            app.Input_Label.Layout.Column = [1 7];
            app.Input_Label.Text = 'Input file details';

            % Create Button_ExportInput
            app.Button_ExportInput = uibutton(app.T1P1_Grid, 'push');
            app.Button_ExportInput.ButtonPushedFcn = createCallbackFcn(app, @exportInputButtonPushed, true);
            app.Button_ExportInput.Layout.Row = 2;
            app.Button_ExportInput.Layout.Column = 11;
            app.Button_ExportInput.Text = 'Export Input';

            % Create Button_ExportOutput
            app.Button_ExportOutput = uibutton(app.T1P1_Grid, 'push');
            app.Button_ExportOutput.ButtonPushedFcn = createCallbackFcn(app, @exportOutputButtonPushed, true);
            app.Button_ExportOutput.Layout.Row = 2;
            app.Button_ExportOutput.Layout.Column = 12;
            app.Button_ExportOutput.Text = 'Export Output';

            % Create LossidBLabel
            app.LossidBLabel = uilabel(app.T1P1_Grid);
            app.LossidBLabel.HorizontalAlignment = 'right';
            app.LossidBLabel.Layout.Row = 3;
            app.LossidBLabel.Layout.Column = 1;
            app.LossidBLabel.Text = 'Loss (dB):';

            % Create Input_Loss
            app.Input_Loss = uispinner(app.T1P1_Grid);
            app.Input_Loss.Layout.Row = 3;
            app.Input_Loss.Layout.Column = 2;

            % Create IncidentWaveARRw_dBLabel
            app.IncidentWaveARRw_dBLabel = uilabel(app.T1P1_Grid);
            app.IncidentWaveARRw_dBLabel.HorizontalAlignment = 'right';
            app.IncidentWaveARRw_dBLabel.Layout.Row = 3;
            app.IncidentWaveARRw_dBLabel.Layout.Column = 3;
            app.IncidentWaveARRw_dBLabel.Text = 'Rw (Incident Wave AR dB):';

            % Create Input_Rw
            app.Input_Rw = uispinner(app.T1P1_Grid);
            app.Input_Rw.Layout.Row = 3;
            app.Input_Rw.Layout.Column = 4;
            app.Input_Rw.Value = 6;

            % Create TxPowerdBLabel
            app.TxPowerdBLabel = uilabel(app.T1P1_Grid);
            app.TxPowerdBLabel.HorizontalAlignment = 'right';
            app.TxPowerdBLabel.Layout.Row = 3;
            app.TxPowerdBLabel.Layout.Column = 5;
            app.TxPowerdBLabel.Text = 'Pt (Tx Power):';

            % Create Input_Pt
            app.Input_Pt = uispinner(app.T1P1_Grid);
            app.Input_Pt.Layout.Row = 3;
            app.Input_Pt.Layout.Column = 6;

            % Create DropDown_Pt
            app.DropDown_Pt = uidropdown(app.T1P1_Grid);
            app.DropDown_Pt.Items = {'dBW', 'dBm', 'Watts'};
            app.DropDown_Pt.Layout.Row = 3;
            app.DropDown_Pt.Layout.Column = 7;
            app.DropDown_Pt.Value = 'dBW';

            % Create DistanceLabel
            app.DistanceLabel = uilabel(app.T1P1_Grid);
            app.DistanceLabel.HorizontalAlignment = 'right';
            app.DistanceLabel.Layout.Row = 3;
            app.DistanceLabel.Layout.Column = 8;
            app.DistanceLabel.Text = 'R (E-field Range, m):';

            % Create Input_Distance
            app.Input_Distance = uispinner(app.T1P1_Grid);
            app.Input_Distance.Layout.Row = 3;
            app.Input_Distance.Layout.Column = 9;
            app.Input_Distance.Value = 1;

            % Create DropDown_Orientation
            app.DropDown_Orientation = uidropdown(app.T1P1_Grid);
            app.DropDown_Orientation.Items = {'Orientation:', '+Z', '-Z', '+X', '-X', '+Y', '-Y'};
            app.DropDown_Orientation.ValueChangedFcn = createCallbackFcn(app, @covOrientationChanged, true);
            app.DropDown_Orientation.Layout.Row = 3;
            app.DropDown_Orientation.Layout.Column = 10;
            app.DropDown_Orientation.Value = 'Orientation:';

            % Create DropDown_Orientation_3
            app.DropDown_Orientation_3 = uidropdown(app.T1P1_Grid);
            app.DropDown_Orientation_3.Items = {'Select STEP', 'STEP: 1°'};
            app.DropDown_Orientation_3.Layout.Row = 3;
            app.DropDown_Orientation_3.Layout.Column = 11;
            app.DropDown_Orientation_3.Value = 'Select STEP';

            % Create DominantPolLabel
            app.DominantPolLabel = uilabel(app.T1P1_Grid);
            app.DominantPolLabel.Layout.Row = 2;
            app.DominantPolLabel.Layout.Column = 6;
            app.DominantPolLabel.Text = 'Dominant Pol';

            % Create Label_MaxGain
            app.Label_MaxGain = uilabel(app.T1P1_Grid);
            app.Label_MaxGain.Layout.Row = 2;
            app.Label_MaxGain.Layout.Column = [7 8];
            app.Label_MaxGain.Text = 'Max Gain (θ/φ)';

            % Create Label_MaxInputE
            app.Label_MaxInputE = uilabel(app.T1P1_Grid);
            app.Label_MaxInputE.Layout.Row = 2;
            app.Label_MaxInputE.Layout.Column = [9 10];
            app.Label_MaxInputE.Text = 'Max Input Eθ/Eφ component';

            % =========================================================
            % ROW 4: SPHERICAL ROTATION UI 
            % =========================================================
            
            % Create DropDown_InitOri
            app.DropDown_InitOri = uidropdown(app.T1P1_Grid);
            app.DropDown_InitOri.Items = {'Source: +X (Forward)', 'Source: -X (Aft)', 'Source: +Y (Stbd)', 'Source: -Y (Port)', 'Source: +Z (Overhead)', 'Source: -Z (Deck)', 'Custom...'};
            app.DropDown_InitOri.ValueChangedFcn = createCallbackFcn(app, @syncSourceOrientationSpinners, true);
            app.DropDown_InitOri.Layout.Row = 4;
            app.DropDown_InitOri.Layout.Column = 1;
            app.DropDown_InitOri.Value = 'Source: +Z (Overhead)';
            
            % Create Label_SrcTheta
            app.Label_SrcTheta = uilabel(app.T1P1_Grid);
            app.Label_SrcTheta.HorizontalAlignment = 'right';
            app.Label_SrcTheta.Layout.Row = 4;
            app.Label_SrcTheta.Layout.Column = 2;
            app.Label_SrcTheta.Text = 'Src Θ:';
            
            % Create Input_SrcTheta
            app.Input_SrcTheta = uispinner(app.T1P1_Grid);
            app.Input_SrcTheta.ValueChangedFcn = createCallbackFcn(app, @setSourceCustomMode, true);
            app.Input_SrcTheta.Layout.Row = 4;
            app.Input_SrcTheta.Layout.Column = 3;
            app.Input_SrcTheta.Limits = [-360 360];
            app.Input_SrcTheta.Value = 0; % Overhead +Z is theta=0
            
            % Create Label_SrcPhi
            app.Label_SrcPhi = uilabel(app.T1P1_Grid);
            app.Label_SrcPhi.HorizontalAlignment = 'right';
            app.Label_SrcPhi.Layout.Row = 4;
            app.Label_SrcPhi.Layout.Column = 4;
            app.Label_SrcPhi.Text = 'Src Φ:';
            
            % Create Input_SrcPhi
            app.Input_SrcPhi = uispinner(app.T1P1_Grid);
            app.Input_SrcPhi.ValueChangedFcn = createCallbackFcn(app, @setSourceCustomMode, true);
            app.Input_SrcPhi.Layout.Row = 4;
            app.Input_SrcPhi.Layout.Column = 5;
            app.Input_SrcPhi.Limits = [-360 360];
            app.Input_SrcPhi.Value = 0;

            % Create Label_RotTheta
            app.Label_RotTheta = uilabel(app.T1P1_Grid);
            app.Label_RotTheta.HorizontalAlignment = 'right';
            app.Label_RotTheta.Layout.Row = 4;
            app.Label_RotTheta.Layout.Column = 6;
            app.Label_RotTheta.Text = 'Dest Θ:';

            % Create Input_RotTheta
            app.Input_RotTheta = uispinner(app.T1P1_Grid);
            app.Input_RotTheta.Layout.Row = 4;
            app.Input_RotTheta.Layout.Column = 7;
            app.Input_RotTheta.Limits = [-360 360];

            % Create Label_RotPhi
            app.Label_RotPhi = uilabel(app.T1P1_Grid);
            app.Label_RotPhi.HorizontalAlignment = 'right';
            app.Label_RotPhi.Layout.Row = 4;
            app.Label_RotPhi.Layout.Column = 8;
            app.Label_RotPhi.Text = 'Dest Φ:';

            % Create Input_RotPhi
            app.Input_RotPhi = uispinner(app.T1P1_Grid);
            app.Input_RotPhi.Layout.Row = 4;
            app.Input_RotPhi.Layout.Column = 9;
            app.Input_RotPhi.Limits = [-360 360];

            % Create Button_Rotate
            app.Button_Rotate = uibutton(app.T1P1_Grid, 'push');
            app.Button_Rotate.ButtonPushedFcn = createCallbackFcn(app, @rotatePatternButtonPushed, true);
            app.Button_Rotate.Layout.Row = 4;
            app.Button_Rotate.Layout.Column = [10 11];
            app.Button_Rotate.Text = 'Target Boresight';
            
            % Create ComputeCoverageButton
            app.ComputeCoverageButton = uibutton(app.T1P1_Grid, 'push');
            app.ComputeCoverageButton.ButtonPushedFcn = createCallbackFcn(app, @computeCoverageT1ButtonPushed, true);
            app.ComputeCoverageButton.Layout.Row = 4;
            app.ComputeCoverageButton.Layout.Column = 12;
            app.ComputeCoverageButton.Text = 'Compute Coverage';

            % Create Panel_PlotControls
            app.Panel_PlotControls = uipanel(app.Tab1_Grid);
            app.Panel_PlotControls.Title = 'Plot Controls';
            app.Panel_PlotControls.Layout.Row = 2;
            app.Panel_PlotControls.Layout.Column = 3;

            % Create Grid_PlotCtrl
            app.Grid_PlotCtrl = uigridlayout(app.Panel_PlotControls);
            app.Grid_PlotCtrl.RowHeight = {22, 22, 22, 22, 22, 22, 22, 22, 22};

            % Create ComponentLabel
            app.ComponentLabel = uilabel(app.Grid_PlotCtrl);
            app.ComponentLabel.HorizontalAlignment = 'right';
            app.ComponentLabel.Layout.Row = 1;
            app.ComponentLabel.Layout.Column = 1;
            app.ComponentLabel.Text = 'Component:';

            % Create DropDown_Component
            app.DropDown_Component = uidropdown(app.Grid_PlotCtrl);
            app.DropDown_Component.ValueChangedFcn = createCallbackFcn(app, @updatePlotsEvent, true);
            app.DropDown_Component.Items = {'Total Gain', 'RHCP Gain', 'LHCP  Gain', 'Axial Ratio', 'Polarized Gain'};
            app.DropDown_Component.Layout.Row = 1;
            app.DropDown_Component.Layout.Column = 2;
            app.DropDown_Component.Value = 'Total Gain';

            % Create Label_PlaneMode
            app.Label_PlaneMode = uilabel(app.Grid_PlotCtrl);
            app.Label_PlaneMode.HorizontalAlignment = 'right';
            app.Label_PlaneMode.Layout.Row = 2;
            app.Label_PlaneMode.Layout.Column = 1;
            app.Label_PlaneMode.Text = 'Plot Mode:';

            % Create DropDown_PlaneMode
            app.DropDown_PlaneMode = uidropdown(app.Grid_PlotCtrl);
            app.DropDown_PlaneMode.ValueChangedFcn = createCallbackFcn(app, @planeModeChangedEvent, true);
            app.DropDown_PlaneMode.Items = {'Auto E-Plane', 'Auto H-Plane', 'Manual Cut'};
            app.DropDown_PlaneMode.Layout.Row = 2;
            app.DropDown_PlaneMode.Layout.Column = 2;
            app.DropDown_PlaneMode.Value = 'Auto E-Plane';

            % Create CuttypeDropDownLabel
            app.CuttypeDropDownLabel = uilabel(app.Grid_PlotCtrl);
            app.CuttypeDropDownLabel.HorizontalAlignment = 'right';
            app.CuttypeDropDownLabel.Layout.Row = 3;
            app.CuttypeDropDownLabel.Layout.Column = 1;
            app.CuttypeDropDownLabel.Text = 'Cut type:';

            % Create DropDown_CutType
            app.DropDown_CutType = uidropdown(app.Grid_PlotCtrl);
            app.DropDown_CutType.ValueChangedFcn = createCallbackFcn(app, @updateCutPlotsEvent, true);
            app.DropDown_CutType.Items = {'Phi Cut', 'Theta Cut'};
            app.DropDown_CutType.Layout.Row = 3;
            app.DropDown_CutType.Layout.Column = 2;
            app.DropDown_CutType.Value = 'Phi Cut';

            % Create CutvalueLabel
            app.CutvalueLabel = uilabel(app.Grid_PlotCtrl);
            app.CutvalueLabel.HorizontalAlignment = 'right';
            app.CutvalueLabel.Layout.Row = 4;
            app.CutvalueLabel.Layout.Column = 1;
            app.CutvalueLabel.Text = 'Cut value:';

            % Create Input_Cut_Value
            app.Input_Cut_Value = uispinner(app.Grid_PlotCtrl);
            app.Input_Cut_Value.ValueChangedFcn = createCallbackFcn(app, @updateCutPlotsEvent, true);
            app.Input_Cut_Value.Limits = [0 360];
            app.Input_Cut_Value.Layout.Row = 4;
            app.Input_Cut_Value.Layout.Column = 2;

            % Create ColorbarminLabel
            app.ColorbarminLabel = uilabel(app.Grid_PlotCtrl);
            app.ColorbarminLabel.HorizontalAlignment = 'right';
            app.ColorbarminLabel.Layout.Row = 5;
            app.ColorbarminLabel.Layout.Column = 1;
            app.ColorbarminLabel.Text = 'Colorbar min:';

            % Create Input_Plot_Cmin
            app.Input_Plot_Cmin = uispinner(app.Grid_PlotCtrl);
            app.Input_Plot_Cmin.ValueChangedFcn = createCallbackFcn(app, @updatePlotsEvent, true);
            app.Input_Plot_Cmin.Layout.Row = 5;
            app.Input_Plot_Cmin.Layout.Column = 2;
            app.Input_Plot_Cmin.Value = -40;

            % Create ColorbarmaxLabel
            app.ColorbarmaxLabel = uilabel(app.Grid_PlotCtrl);
            app.ColorbarmaxLabel.HorizontalAlignment = 'right';
            app.ColorbarmaxLabel.Layout.Row = 6;
            app.ColorbarmaxLabel.Layout.Column = 1;
            app.ColorbarmaxLabel.Text = 'Colorbar max:';

            % Create Input_Plot_Cmax
            app.Input_Plot_Cmax = uispinner(app.Grid_PlotCtrl);
            app.Input_Plot_Cmax.ValueChangedFcn = createCallbackFcn(app, @updatePlotsEvent, true);
            app.Input_Plot_Cmax.Layout.Row = 6;
            app.Input_Plot_Cmax.Layout.Column = 2;
            app.Input_Plot_Cmax.Value = 10;

            % Create ColorbarstepLabel
            app.ColorbarstepLabel = uilabel(app.Grid_PlotCtrl);
            app.ColorbarstepLabel.HorizontalAlignment = 'right';
            app.ColorbarstepLabel.Layout.Row = 7;
            app.ColorbarstepLabel.Layout.Column = 1;
            app.ColorbarstepLabel.Text = 'Colorbar step:';

            % Create Input_Plot_Cstep
            app.Input_Plot_Cstep = uispinner(app.Grid_PlotCtrl);
            app.Input_Plot_Cstep.ValueChangedFcn = createCallbackFcn(app, @updatePlotsEvent, true);
            app.Input_Plot_Cstep.Layout.Row = 7;
            app.Input_Plot_Cstep.Layout.Column = 2;
            app.Input_Plot_Cstep.Value = 10;

            % Create CheckBox_Grid
            app.CheckBox_Grid = uicheckbox(app.Grid_PlotCtrl);
            app.CheckBox_Grid.ValueChangedFcn = createCallbackFcn(app, @updatePlotsEvent, true);
            app.CheckBox_Grid.Text = 'Show Pattern Grids';
            app.CheckBox_Grid.Layout.Row = 8;
            app.CheckBox_Grid.Layout.Column = [1 2];
            app.CheckBox_Grid.Value = true;

            % Create CheckBox_NegAxes — toggle negative XYZ axes on 3D plots
            app.CheckBox_NegAxes = uicheckbox(app.Grid_PlotCtrl);
            app.CheckBox_NegAxes.ValueChangedFcn = createCallbackFcn(app, @updatePlotsEvent, true);
            app.CheckBox_NegAxes.Text = 'Show -XYZ Axes';
            app.CheckBox_NegAxes.Layout.Row = 9;
            app.CheckBox_NegAxes.Layout.Column = [1 2];
            app.CheckBox_NegAxes.Value = false;

            % Create Panel_Pattern
            app.Panel_Pattern = uipanel(app.Tab1_Grid);
            app.Panel_Pattern.Title = 'Full Antenna Pattern';
            app.Panel_Pattern.Layout.Row = [2 3];
            app.Panel_Pattern.Layout.Column = 1;

            % Create Grid_Pattern
            app.Grid_Pattern = uigridlayout(app.Panel_Pattern);
            app.Grid_Pattern.ColumnWidth = {'1x'};
            app.Grid_Pattern.RowHeight = {'1x'};

            % Create Tabs_Pattern
            app.Tabs_Pattern = uitabgroup(app.Grid_Pattern);
            app.Tabs_Pattern.Layout.Row = 1;
            app.Tabs_Pattern.Layout.Column = 1;

            % Create Tab1_Contour
            app.Tab1_Contour = uitab(app.Tabs_Pattern);
            app.Tab1_Contour.Title = 'Contour';

            % Create Grid_Contour
            app.Grid_Contour = uigridlayout(app.Tab1_Contour);
            app.Grid_Contour.ColumnWidth = {'1x'};
            app.Grid_Contour.RowHeight = {'1x'};

            % Create Axes_Contour
            app.Axes_Contour = uiaxes(app.Grid_Contour);
            % title(app.Axes_Contour, 'Title')
            % xlabel(app.Axes_Contour, 'X')
            % ylabel(app.Axes_Contour, 'Y')
            % zlabel(app.Axes_Contour, 'Z')
            app.Axes_Contour.Layout.Row = 1;
            app.Axes_Contour.Layout.Column = 1;
            colormap(app.Axes_Contour, 'jet')
            app.Axes_Contour.Box = 'on';

            % Create Tab2_Circular
            app.Tab2_Circular = uitab(app.Tabs_Pattern);
            app.Tab2_Circular.Title = 'Polar';

            % Create Grid_Circular
            app.Grid_Circular = uigridlayout(app.Tab2_Circular);
            app.Grid_Circular.ColumnWidth = {'1x'};
            app.Grid_Circular.RowHeight = {'1x'};

            % Create Axes_Circular
            app.Axes_Circular = uiaxes(app.Grid_Circular);
            % title(app.Axes_Circular, 'Title')
            % xlabel(app.Axes_Circular, 'X')
            % ylabel(app.Axes_Circular, 'Y')
            % zlabel(app.Axes_Circular, 'Z')
            app.Axes_Circular.Layout.Row = 1;
            app.Axes_Circular.Layout.Column = 1;
            colormap(app.Axes_Circular, 'jet')

            % Create Tab3_Spherical
            app.Tab3_Spherical = uitab(app.Tabs_Pattern);
            app.Tab3_Spherical.Title = 'Spherical';

            % Create Grid_Spherical
            app.Grid_Spherical = uigridlayout(app.Tab3_Spherical);
            app.Grid_Spherical.ColumnWidth = {'1x'};
            app.Grid_Spherical.RowHeight = {'1x'};

            % Create Axes_Spherical
            app.Axes_Spherical = uiaxes(app.Grid_Spherical);
            app.Axes_Spherical.Layout.Row = 1;
            app.Axes_Spherical.Layout.Column = 1;
            app.Axes_Spherical.View = [135 30];
            colormap(app.Axes_Spherical, 'jet');

            % Create Tab4_3D
            app.Tab4_3D = uitab(app.Tabs_Pattern);
            app.Tab4_3D.Title = '3D Pattern';

            % Create Grid_3D
            app.Grid_3D = uigridlayout(app.Tab4_3D);
            app.Grid_3D.ColumnWidth = {'1x'};
            app.Grid_3D.RowHeight = {'1x'};

            % Create Axes_3D
            app.Axes_3D = uiaxes(app.Grid_3D);
            app.Axes_3D.Layout.Row = 1;
            app.Axes_3D.Layout.Column = 1;
            app.Axes_3D.View = [135 30];
            colormap(app.Axes_3D, 'jet');

            % Create Panel_Cuts
            app.Panel_Cuts = uipanel(app.Tab1_Grid);
            app.Panel_Cuts.Title = 'Antenna Pattern Cut';
            app.Panel_Cuts.Layout.Row = [2 3];
            app.Panel_Cuts.Layout.Column = 2;

            % Create Grid_Cuts
            app.Grid_Cuts = uigridlayout(app.Panel_Cuts);
            app.Grid_Cuts.ColumnWidth = {'1x', 'fit'};
            app.Grid_Cuts.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x'};

            % Create Tabs_Cuts
            app.Tabs_Cuts = uitabgroup(app.Grid_Cuts);
            app.Tabs_Cuts.Layout.Row = [1 6];
            app.Tabs_Cuts.Layout.Column = 1;

            % Create Tab_Polar
            app.Tab_Polar = uitab(app.Tabs_Cuts);
            app.Tab_Polar.Title = 'Polar';

            % Create Grid_Polar
            app.Grid_Polar = uigridlayout(app.Tab_Polar);
            app.Grid_Polar.ColumnWidth = {'1x'};
            app.Grid_Polar.RowHeight = {'1x'};

            % Create Tab_Rect
            app.Tab_Rect = uitab(app.Tabs_Cuts);
            app.Tab_Rect.Title = 'Rectangular';

            % Create Grid_Rect
            app.Grid_Rect = uigridlayout(app.Tab_Rect);
            app.Grid_Rect.ColumnWidth = {'1x'};
            app.Grid_Rect.RowHeight = {'1x'};

            % Create Axes_Rect
            app.Axes_Rect = uiaxes(app.Grid_Rect);
            % title(app.Axes_Rect, 'Title')
            % xlabel(app.Axes_Rect, 'X')
            % ylabel(app.Axes_Rect, 'Y')
            % zlabel(app.Axes_Rect, 'Z')
            % colormap(app.Axes_Rect, 'jet')
            app.Axes_Rect.Layout.Row = 1;
            app.Axes_Rect.Layout.Column = 1;
            app.Axes_Rect.Box = 'on';

            % Create Tab_FilledPolar — Balanis-style gradient-filled polar radiation pattern
            app.Tab_FilledPolar = uitab(app.Tabs_Cuts);
            app.Tab_FilledPolar.Title = 'Filled Polar';

            % Create Grid_FilledPolar
            app.Grid_FilledPolar = uigridlayout(app.Tab_FilledPolar);
            app.Grid_FilledPolar.ColumnWidth = {'1x'};
            app.Grid_FilledPolar.RowHeight = {'1x'};

            % Create Axes_FilledPolar
            app.Axes_FilledPolar = uiaxes(app.Grid_FilledPolar);
            app.Axes_FilledPolar.Layout.Row = 1;
            app.Axes_FilledPolar.Layout.Column = 1;
            colormap(app.Axes_FilledPolar, 'jet');

            % Create HPBWButton — State toggle: ON computes beam metrics + overlay, OFF clears
            app.HPBWButton = uibutton(app.Grid_Cuts, 'state');
            app.HPBWButton.ValueChangedFcn = createCallbackFcn(app, @hpbwButtonPushed, true);
            app.HPBWButton.Layout.Row = 1;
            app.HPBWButton.Layout.Column = 2;
            app.HPBWButton.Text = 'HPBW';

            % Create Label_HPBW
            app.Label_HPBW = uilabel(app.Grid_Cuts);
            app.Label_HPBW.Layout.Row = 2;
            app.Label_HPBW.Layout.Column = 2;
            app.Label_HPBW.Text = '';

            % Create E_TotalCheckBox
            app.E_TotalCheckBox = uicheckbox(app.Grid_Cuts);
            app.E_TotalCheckBox.ValueChangedFcn = createCallbackFcn(app, @updateCutPlotsEvent, true);
            app.E_TotalCheckBox.Text = 'E_Total';
            app.E_TotalCheckBox.Layout.Row = 3;
            app.E_TotalCheckBox.Layout.Column = 2;
            app.E_TotalCheckBox.Value = true;

            % Create E_RHCPCheckBox
            app.E_RHCPCheckBox = uicheckbox(app.Grid_Cuts);
            app.E_RHCPCheckBox.ValueChangedFcn = createCallbackFcn(app, @updateCutPlotsEvent, true);
            app.E_RHCPCheckBox.Text = 'E_RHCP';
            app.E_RHCPCheckBox.Layout.Row = 4;
            app.E_RHCPCheckBox.Layout.Column = 2;
            app.E_RHCPCheckBox.Value = true;

            % Create E_LHCPCheckBox
            app.E_LHCPCheckBox = uicheckbox(app.Grid_Cuts);
            app.E_LHCPCheckBox.ValueChangedFcn = createCallbackFcn(app, @updateCutPlotsEvent, true);
            app.E_LHCPCheckBox.Text = 'E_LHCP';
            app.E_LHCPCheckBox.Layout.Row = 5;
            app.E_LHCPCheckBox.Layout.Column = 2;
            app.E_LHCPCheckBox.Value = true;

            % Create ExportCutButton
            app.ExportCutButton = uibutton(app.Grid_Cuts, 'push');
            app.ExportCutButton.ButtonPushedFcn = createCallbackFcn(app, @exportCutButtonPushed, true);
            app.ExportCutButton.Layout.Row = 6;
            app.ExportCutButton.Layout.Column = 2;
            app.ExportCutButton.Text = 'Export Cut';

            % Create TabsData
            app.TabsData = uitabgroup(app.Tab1_Grid);
            app.TabsData.Layout.Row = 4;
            app.TabsData.Layout.Column = [1 3];

            % Create Tab_Output
            app.Tab_Output = uitab(app.TabsData);
            app.Tab_Output.Title = 'Output';

            % Create Grid_Output
            app.Grid_Output = uigridlayout(app.Tab_Output);
            app.Grid_Output.ColumnWidth = {'1x'};
            app.Grid_Output.RowHeight = {'1x'};

            % Create Table_DataOut
            app.Table_DataOut = uitable(app.Grid_Output);
            app.Table_DataOut.ColumnName = {'Theta'; 'Phi'; 'E_Total_dB'; 'E_RCP_dB'; 'E_LCP_dB'; 'E_RCP_Phase'; 'E_LCP_Phase'; 'AR_dB'; 'PLF_dB'; 'Gain_Polarized'; 'EIRP_dBW'; 'PFD_Wm2'; 'E_field_Vm'};
            app.Table_DataOut.ColumnRearrangeable = 'on';
            app.Table_DataOut.RowName = {};
            app.Table_DataOut.ColumnSortable = true;
            app.Table_DataOut.Layout.Row = 1;
            app.Table_DataOut.Layout.Column = 1;

            % Create Tab_Input
            app.Tab_Input = uitab(app.TabsData);
            app.Tab_Input.Title = 'Input';

            % Create Grid_Input
            app.Grid_Input = uigridlayout(app.Tab_Input);
            app.Grid_Input.ColumnWidth = {'1x'};
            app.Grid_Input.RowHeight = {'1x'};

            % Create Table_DataIn
            app.Table_DataIn = uitable(app.Grid_Input);
            app.Table_DataIn.ColumnName = {'Theta'; 'Phi'; 'E-TH-DB'; 'E-PH-DB'; 'E-TH-DG'; 'E-PH-DG'};
            app.Table_DataIn.RowName = {};
            app.Table_DataIn.Layout.Row = 1;
            app.Table_DataIn.Layout.Column = 1;

            % Create DropDown_output
            app.DropDown_output = uidropdown(app.Tab1_Grid);
            app.DropDown_output.Items = {'Filter Output:'};
            app.DropDown_output.Layout.Row = 3;
            app.DropDown_output.Layout.Column = 3;
            app.DropDown_output.Value = 'Filter Output:';

            % Create Tab2
            app.Tab2 = uitab(app.TabGroup);
            app.Tab2.Title = 'Batch Processing';

            % Create Tab2_Grid
            app.Tab2_Grid = uigridlayout(app.Tab2);
            app.Tab2_Grid.ColumnWidth = {'1x', '1x', '1x'};
            app.Tab2_Grid.RowHeight = {'fit', '1.5x', '1x'};

            % Create Tab2_Panel1
            app.Tab2_Panel1 = uipanel(app.Tab2_Grid);
            app.Tab2_Panel1.Title = 'Inputs & Parameters';
            app.Tab2_Panel1.Layout.Row = 1;
            app.Tab2_Panel1.Layout.Column = [1 3];

            % Create T2P1_Grid
            app.T2P1_Grid = uigridlayout(app.Tab2_Panel1);
            app.T2P1_Grid.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.T2P1_Grid.RowHeight = {'1x', '1x', '1x'};

            % Create FormatLabel_2
            app.FormatLabel_2 = uilabel(app.T2P1_Grid);
            app.FormatLabel_2.HorizontalAlignment = 'right';
            app.FormatLabel_2.Layout.Row = 1;
            app.FormatLabel_2.Layout.Column = 1;
            app.FormatLabel_2.Text = 'Format:';

            % Create DropDown_Format_2
            app.DropDown_Format_2 = uidropdown(app.T2P1_Grid);
            app.DropDown_Format_2.Items = {'Eθ, Eϕ [mag_dB,phase°]', 'Eθ, Eϕ [Re,Im]', 'Erh, Elh [mag,phase°]', 'Erh, Elh [Re,Im]', 'Gain Pattern'};
            app.DropDown_Format_2.ItemsData = {'1', '2', '3', '4', '5'};
            app.DropDown_Format_2.Layout.Row = 1;
            app.DropDown_Format_2.Layout.Column = 2;
            app.DropDown_Format_2.Value = '1';

            % Create InputFolderLabel
            app.InputFolderLabel = uilabel(app.T2P1_Grid);
            app.InputFolderLabel.HorizontalAlignment = 'right';
            app.InputFolderLabel.Layout.Row = 1;
            app.InputFolderLabel.Layout.Column = 3;
            app.InputFolderLabel.Text = 'Input Folder:';

            % Create Input_PatternField_2
            app.Input_PatternField_2 = uieditfield(app.T2P1_Grid, 'text');
            app.Input_PatternField_2.Editable = 'off';
            app.Input_PatternField_2.Placeholder = '(No folder loaded)';
            app.Input_PatternField_2.Layout.Row = 1;
            app.Input_PatternField_2.Layout.Column = [4 8];

            % Create Button_Load_2
            app.Button_Load_2 = uibutton(app.T2P1_Grid, 'push');
            app.Button_Load_2.Layout.Row = 1;
            app.Button_Load_2.Layout.Column = 9;
            app.Button_Load_2.Text = 'Load';

            % Create Button_Process_2
            app.Button_Process_2 = uibutton(app.T2P1_Grid, 'push');
            app.Button_Process_2.Layout.Row = 1;
            app.Button_Process_2.Layout.Column = 10;
            app.Button_Process_2.Text = 'Process';

            % Create Input_Label_2
            app.Input_Label_2 = uilabel(app.T2P1_Grid);
            app.Input_Label_2.Layout.Row = 2;
            app.Input_Label_2.Layout.Column = [1 6];
            app.Input_Label_2.Text = '';

            % Create Button_ExportInput_2
            app.Button_ExportInput_2 = uibutton(app.T2P1_Grid, 'push');
            app.Button_ExportInput_2.Layout.Row = 2;
            app.Button_ExportInput_2.Layout.Column = 9;
            app.Button_ExportInput_2.Text = 'Export Input';

            % Create Button_ExportOutput_2
            app.Button_ExportOutput_2 = uibutton(app.T2P1_Grid, 'push');
            app.Button_ExportOutput_2.Layout.Row = 2;
            app.Button_ExportOutput_2.Layout.Column = 10;
            app.Button_ExportOutput_2.Text = 'Export Output';

            % Create LossidBLabel_2
            app.LossidBLabel_2 = uilabel(app.T2P1_Grid);
            app.LossidBLabel_2.HorizontalAlignment = 'right';
            app.LossidBLabel_2.Layout.Row = 3;
            app.LossidBLabel_2.Layout.Column = 1;
            app.LossidBLabel_2.Text = 'Loss (dB):';

            % Create Input_Loss_2
            app.Input_Loss_2 = uispinner(app.T2P1_Grid);
            app.Input_Loss_2.Layout.Row = 3;
            app.Input_Loss_2.Layout.Column = 2;

            % Create IncidentWaveARRw_dBLabel_2
            app.IncidentWaveARRw_dBLabel_2 = uilabel(app.T2P1_Grid);
            app.IncidentWaveARRw_dBLabel_2.HorizontalAlignment = 'right';
            app.IncidentWaveARRw_dBLabel_2.Layout.Row = 3;
            app.IncidentWaveARRw_dBLabel_2.Layout.Column = 3;
            app.IncidentWaveARRw_dBLabel_2.Text = 'Rw (Incident Wave AR, dB):';

            % Create Input_Rw_2
            app.Input_Rw_2 = uispinner(app.T2P1_Grid);
            app.Input_Rw_2.Layout.Row = 3;
            app.Input_Rw_2.Layout.Column = 4;
            app.Input_Rw_2.Value = 6;

            % Create TxPowerdBLabel_2
            app.TxPowerdBLabel_2 = uilabel(app.T2P1_Grid);
            app.TxPowerdBLabel_2.HorizontalAlignment = 'right';
            app.TxPowerdBLabel_2.Layout.Row = 3;
            app.TxPowerdBLabel_2.Layout.Column = 5;
            app.TxPowerdBLabel_2.Text = 'Pt (Tx Power):';

            % Create Input_Pt_2
            app.Input_Pt_2 = uispinner(app.T2P1_Grid);
            app.Input_Pt_2.Layout.Row = 3;
            app.Input_Pt_2.Layout.Column = 6;

            % Create DropDown_Pt_2
            app.DropDown_Pt_2 = uidropdown(app.T2P1_Grid);
            app.DropDown_Pt_2.Items = {'dB', 'dBm', 'Watts'};
            app.DropDown_Pt_2.Layout.Row = 3;
            app.DropDown_Pt_2.Layout.Column = 7;
            app.DropDown_Pt_2.Value = 'dB';

            % Create DistanceLabel_2
            app.DistanceLabel_2 = uilabel(app.T2P1_Grid);
            app.DistanceLabel_2.HorizontalAlignment = 'right';
            app.DistanceLabel_2.Layout.Row = 3;
            app.DistanceLabel_2.Layout.Column = 8;
            app.DistanceLabel_2.Text = 'R (E-field Range, m):';

            % Create Input_Distance_2
            app.Input_Distance_2 = uispinner(app.T2P1_Grid);
            app.Input_Distance_2.Layout.Row = 3;
            app.Input_Distance_2.Layout.Column = 9;
            app.Input_Distance_2.Value = 1;

            % Create DropDown_Orientation_2
            app.DropDown_Orientation_2 = uidropdown(app.T2P1_Grid);
            app.DropDown_Orientation_2.Items = {'Orientation:', '+Z', '-Z', '+X', '-X', '+Y', '-Y'};
            app.DropDown_Orientation_2.Layout.Row = 3;
            app.DropDown_Orientation_2.Layout.Column = 10;
            app.DropDown_Orientation_2.Value = 'Orientation:';

            % Create Tab3
            app.Tab3 = uitab(app.TabGroup);
            app.Tab3.Title = 'Coverage Analysis';

            % Create Tab3_Grid
            app.Tab3_Grid = uigridlayout(app.Tab3);
            app.Tab3_Grid.ColumnWidth = {'1x', '1x', '1x'};
            app.Tab3_Grid.RowHeight = {'1x', '1x', '1x'};

            % Create UIAxes
            app.UIAxes = uiaxes(app.Tab3_Grid);
            % title(app.UIAxes, 'Title')
            % xlabel(app.UIAxes, 'X')
            % ylabel(app.UIAxes, 'Y')
            % zlabel(app.UIAxes, 'Z')
            app.UIAxes.Layout.Row = [2 3];
            app.UIAxes.Layout.Column = 2;

            % Create Tab3_Panel1
            app.Tab3_Panel1 = uipanel(app.Tab3_Grid);
            app.Tab3_Panel1.Title = 'Inputs & Parameters';
            app.Tab3_Panel1.Layout.Row = 1;
            app.Tab3_Panel1.Layout.Column = [1 3];

            % Create T3P1_Grid
            app.T3P1_Grid = uigridlayout(app.Tab3_Panel1);
            app.T3P1_Grid.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.T3P1_Grid.RowHeight = {'1x', '1x', '1x'};

            % Create GainPatternLabel
            app.GainPatternLabel = uilabel(app.T3P1_Grid);
            app.GainPatternLabel.HorizontalAlignment = 'right';
            app.GainPatternLabel.Layout.Row = 1;
            app.GainPatternLabel.Layout.Column = 2;
            app.GainPatternLabel.Text = 'Gain Pattern:';

            % Create Input_PatternField_3
            app.Input_PatternField_3 = uieditfield(app.T3P1_Grid, 'text');
            app.Input_PatternField_3.Editable = 'off';
            app.Input_PatternField_3.Placeholder = '(No file loaded)';
            app.Input_PatternField_3.Layout.Row = 1;
            app.Input_PatternField_3.Layout.Column = [3 7];

            % Create Button_Load_3
            app.Button_Load_3 = uibutton(app.T3P1_Grid, 'push');
            app.Button_Load_3.ButtonPushedFcn = createCallbackFcn(app, @loadCovButtonPushed, true);
            app.Button_Load_3.Layout.Row = 1;
            app.Button_Load_3.Layout.Column = 8;
            app.Button_Load_3.Text = 'Load';

            % Create Button_Process_3
            app.Button_Process_3 = uibutton(app.T3P1_Grid, 'push');
            app.Button_Process_3.ButtonPushedFcn = createCallbackFcn(app, @processCovButtonPushed, true);
            app.Button_Process_3.Layout.Row = 1;
            app.Button_Process_3.Layout.Column = 9;
            app.Button_Process_3.Text = 'Process';

            % Create Button_ExportOutput_3
            app.Button_ExportOutput_3 = uibutton(app.T3P1_Grid, 'push');
            app.Button_ExportOutput_3.ButtonPushedFcn = createCallbackFcn(app, @exportCovButtonPushed, true);
            app.Button_ExportOutput_3.Layout.Row = 2;
            app.Button_ExportOutput_3.Layout.Column = 9;
            app.Button_ExportOutput_3.Text = 'Export Output';

            % Create ButtonGroup_Coverage
            app.ButtonGroup_Coverage = uibuttongroup(app.T3P1_Grid);
            app.ButtonGroup_Coverage.SelectionChangedFcn = createCallbackFcn(app, @coverageTypeChanged, true);
            app.ButtonGroup_Coverage.Title = 'Coverage Type';
            app.ButtonGroup_Coverage.Layout.Row = [1 2];
            app.ButtonGroup_Coverage.Layout.Column = 1;

            % Create Button_Conical
            app.Button_Conical = uiradiobutton(app.ButtonGroup_Coverage);
            app.Button_Conical.Text = 'Conical';
            app.Button_Conical.Position = [11 49 65 22];

            % Create Button_Spherical
            app.Button_Spherical = uiradiobutton(app.ButtonGroup_Coverage);
            app.Button_Spherical.Text = 'Spherical';
            app.Button_Spherical.Position = [11 71 72 22];
            app.Button_Spherical.Value = true;

            % Create DropDown_covOrientation
            app.DropDown_covOrientation = uidropdown(app.T3P1_Grid);
            app.DropDown_covOrientation.ValueChangedFcn = createCallbackFcn(app, @covOrientationChanged, true);
            app.DropDown_covOrientation.Items = {'Orientation:', '1. Forward (+X)', '2. Aft (-X)', '3. Starboard (+Y)', '4. Port (-Y)', '5. Overhead (+Z)', '6. Deck (-Z)', '7. Arbitrary Orientation'};
            app.DropDown_covOrientation.ItemsData = {'1', '2', '3', '4', '5', '6', '7', '8'};
            app.DropDown_covOrientation.Layout.Row = 3;
            app.DropDown_covOrientation.Layout.Column = 1;
            app.DropDown_covOrientation.Value = '1';

            % Create ThreshMindBLabel
            app.ThreshMindBLabel = uilabel(app.T3P1_Grid);
            app.ThreshMindBLabel.HorizontalAlignment = 'right';
            app.ThreshMindBLabel.Layout.Row = 2;
            app.ThreshMindBLabel.Layout.Column = 2;
            app.ThreshMindBLabel.Text = 'Thresh Min (dB):';

            % Create Spinner_threshMin
            app.Spinner_threshMin = uispinner(app.T3P1_Grid);
            app.Spinner_threshMin.Limits = [-250 100];
            app.Spinner_threshMin.Layout.Row = 2;
            app.Spinner_threshMin.Layout.Column = 3;
            app.Spinner_threshMin.Value = -30;

            % Create ThreshMindBLabel_2
            app.ThreshMindBLabel_2 = uilabel(app.T3P1_Grid);
            app.ThreshMindBLabel_2.HorizontalAlignment = 'right';
            app.ThreshMindBLabel_2.Layout.Row = 2;
            app.ThreshMindBLabel_2.Layout.Column = 4;
            app.ThreshMindBLabel_2.Text = 'Thresh Max (dB):';

            % Create Spinner_threshMax
            app.Spinner_threshMax = uispinner(app.T3P1_Grid);
            app.Spinner_threshMax.Limits = [-250 100];
            app.Spinner_threshMax.Layout.Row = 2;
            app.Spinner_threshMax.Layout.Column = 5;
            app.Spinner_threshMax.Value = 10;

            % Create StepLabel
            app.StepLabel = uilabel(app.T3P1_Grid);
            app.StepLabel.HorizontalAlignment = 'right';
            app.StepLabel.Layout.Row = 2;
            app.StepLabel.Layout.Column = 6;
            app.StepLabel.Text = 'Step (dB):';

            % Create Spinner_threshStep
            app.Spinner_threshStep = uispinner(app.T3P1_Grid);
            app.Spinner_threshStep.Limits = [0.01 10];
            app.Spinner_threshStep.Layout.Row = 2;
            app.Spinner_threshStep.Layout.Column = 7;
            app.Spinner_threshStep.Value = 0.5;

            % Create Cone0Label
            app.Cone0Label = uilabel(app.T3P1_Grid);
            app.Cone0Label.HorizontalAlignment = 'right';
            app.Cone0Label.Enable = 'off';
            app.Cone0Label.Layout.Row = 3;
            app.Cone0Label.Layout.Column = 2;
            app.Cone0Label.Text = 'Cone θ0(°):';

            % Create Spinner_coneTH
            app.Spinner_coneTH = uispinner(app.T3P1_Grid);
            app.Spinner_coneTH.Limits = [0 360];
            app.Spinner_coneTH.Enable = 'off';
            app.Spinner_coneTH.Layout.Row = 3;
            app.Spinner_coneTH.Layout.Column = 3;

            % Create ConeLabel
            app.ConeLabel = uilabel(app.T3P1_Grid);
            app.ConeLabel.HorizontalAlignment = 'right';
            app.ConeLabel.Enable = 'off';
            app.ConeLabel.Layout.Row = 3;
            app.ConeLabel.Layout.Column = 4;
            app.ConeLabel.Text = 'Cone φ(°)';

            % Create Spinner_conePH
            app.Spinner_conePH = uispinner(app.T3P1_Grid);
            app.Spinner_conePH.Limits = [0 360];
            app.Spinner_conePH.Enable = 'off';
            app.Spinner_conePH.Layout.Row = 3;
            app.Spinner_conePH.Layout.Column = 5;

            % Create CongAngleLabel
            app.CongAngleLabel = uilabel(app.T3P1_Grid);
            app.CongAngleLabel.HorizontalAlignment = 'right';
            app.CongAngleLabel.Enable = 'off';
            app.CongAngleLabel.Layout.Row = 3;
            app.CongAngleLabel.Layout.Column = 6;
            app.CongAngleLabel.Text = 'Cone Angle α (°):';

            % Create Spinner_coneAng
            app.Spinner_coneAng = uispinner(app.T3P1_Grid);
            app.Spinner_coneAng.Limits = [0 360];
            app.Spinner_coneAng.Enable = 'off';
            app.Spinner_coneAng.Layout.Row = 3;
            app.Spinner_coneAng.Layout.Column = 7;
            app.Spinner_coneAng.Value = 45;

            % Create Button
            app.Button = uibutton(app.T3P1_Grid, 'push');
            app.Button.ButtonPushedFcn = createCallbackFcn(app, @clearCovButtonPushed, true);
            app.Button.Layout.Row = 2;
            app.Button.Layout.Column = 8;
            app.Button.Text = 'Clear';

            % Create Tree (starts empty — nodes added dynamically)
            app.Tree = uitree(app.Tab3_Grid, 'checkbox');
            app.Tree.CheckedNodesChangedFcn = createCallbackFcn(app, @covTreeCheckedChanged, true);
            app.Tree.DoubleClickedFcn = createCallbackFcn(app, @covTreeDoubleClicked, true);
            app.Tree.Layout.Row = [2 3];
            app.Tree.Layout.Column = 1;

            % Create UITable
            app.UITable = uitable(app.Tab3_Grid);
            app.UITable.ColumnName = {};
            app.UITable.RowName = {};
            app.UITable.Layout.Row = [2 3];
            app.UITable.Layout.Column = 3;

            % Create Tab4
            app.Tab4 = uitab(app.TabGroup);
            app.Tab4.Title = 'Array Analysis (Combine Patterns)';
            
            % Create Tab4_Grid
            app.Tab4_Grid = uigridlayout(app.Tab4);
            app.Tab4_Grid.ColumnWidth = {'1x', '2x'};
            app.Tab4_Grid.RowHeight = {'1x'};
            
            % Create Panel_ArrayConfig
            app.Panel_ArrayConfig = uipanel(app.Tab4_Grid);
            app.Panel_ArrayConfig.Title = 'Array Elements & Phase Tuning';
            app.Panel_ArrayConfig.Layout.Row = 1;
            app.Panel_ArrayConfig.Layout.Column = 1;

            % Create Grid_ArrayConfig
            app.Grid_ArrayConfig = uigridlayout(app.Panel_ArrayConfig);
            app.Grid_ArrayConfig.RowHeight = {30, '1x', 30};
            app.Grid_ArrayConfig.ColumnWidth = {'1x', '1x', '1x'};

            % Create Button_LoadArray
            app.Button_LoadArray = uibutton(app.Grid_ArrayConfig, 'push');
            app.Button_LoadArray.ButtonPushedFcn = createCallbackFcn(app, @loadArrayButtonPushed, true);
            app.Button_LoadArray.Layout.Row = 1;
            app.Button_LoadArray.Layout.Column = [1 2];
            app.Button_LoadArray.Text = 'Load Beams...';

            % Create Button_ClearArray
            app.Button_ClearArray = uibutton(app.Grid_ArrayConfig, 'push');
            app.Button_ClearArray.ButtonPushedFcn = createCallbackFcn(app, @clearArrayButtonPushed, true);
            app.Button_ClearArray.Layout.Row = 1;
            app.Button_ClearArray.Layout.Column = 3;
            app.Button_ClearArray.Text = 'Clear All';

            % Create Table_ArraySetup
            app.Table_ArraySetup = uitable(app.Grid_ArrayConfig);
            app.Table_ArraySetup.ColumnName = {'Beam File', 'Mag (W)', 'Phase (°)'};
            app.Table_ArraySetup.ColumnEditable = [false true true];
            app.Table_ArraySetup.CellEditCallback = createCallbackFcn(app, @arrayTableEdited, true);
            app.Table_ArraySetup.Layout.Row = 2;
            app.Table_ArraySetup.Layout.Column = [1 3];

            % Create Button_ComputeArray
            app.Button_ComputeArray = uibutton(app.Grid_ArrayConfig, 'push');
            app.Button_ComputeArray.ButtonPushedFcn = createCallbackFcn(app, @computeArrayButtonPushed, true);
            app.Button_ComputeArray.Layout.Row = 3;
            app.Button_ComputeArray.Layout.Column = [1 3];
            app.Button_ComputeArray.Text = 'Synthesize Array & Update Plot';

            % Create Axes_Array3D
            app.Axes_Array3D = uiaxes(app.Tab4_Grid);
            app.Axes_Array3D.Layout.Row = 1;
            app.Axes_Array3D.Layout.Column = 2;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = APA_v01_58_gm

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end