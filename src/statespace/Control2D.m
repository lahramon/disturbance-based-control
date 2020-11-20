%   This class defines a template for creating a custom state space definition
%   that can be used by the sampling-based path planners like plannerRRT and
%   plannerRRTStar. The state space allows sampling, interpolation, and calculating
%   the distance between states.
%
%   To access documentation for how to define a state space, enter the following
%   at the MATLAB command prompt:
%
%    >> doc nav.StateSpace
%
%   For a concrete implementation of the same interface, see the following
%   nav.StateSpace class:
%
%    >> edit stateSpaceSE2
%
%
%   To use this custom state space for path planning, follow the steps
%   outlined below and complete the class definition. Then, save this
%   file somewhere on the MATLAB path. You can add a folder to the
%   path using the ADDPATH function.




classdef Control2D < nav.StateSpace & ...
        matlabshared.planning.internal.EnforceScalarHandle
    
    %---------------------------------------------------------------------
    % Step 1: Define properties to be used by your state space.
    % All properties in this section are user-defined properties.
    properties
        
        %UniformDistribution - Uniform distribution for sampling
        UniformDistribution
        
        %NormalDistribution - Normal distribution for sampling
        NormalDistribution
        
        %------------------------------------------------------------------
        % Place your properties here or replace default properties.
        %------------------------------------------------------------------
        %StateBounds
        TransitionMatrix
    end
    
    %----------------------------------------------------------------------
    % Step 2: Define functions used for managing your state space.
    methods
        % a) Use the constructor to set the name of the state space, the
        %    number of state variables, and to define its boundaries.
        %
        function obj = Control2D(nx,ny,nu,transition)
            
            spaceName = "Control2D";
            numStateVariables = 3;
            
            % For each state variable define the lower and upper valid
            % limit (one [min,max] limit per row)
            stateBounds = [1 nx; 1 ny; 1 nu];
            
            % Call the constructor of the base class
            obj@nav.StateSpace(spaceName, numStateVariables, stateBounds);
            
            % Create the probability distributions for sampling.
            obj.NormalDistribution = matlabshared.tracking.internal.NormalDistribution(numStateVariables);
            obj.UniformDistribution = matlabshared.tracking.internal.UniformDistribution(numStateVariables);
            
            %--------------------------------------------------------------
            % Place your code here or replace default function behavior.
            %--------------------------------------------------------------
            obj.TransitionMatrix = transition;
            % obj.StateBounds = stateBounds;
        end
        
        % b) Define how the object is being copied (a new object is created
        %    from the current one). You have to customize this function
        %    if you define your own properties or special constructor.
        %
        %    For more help, see
        %    >> doc nav.StateSpace/copy
        %
        function copyObj = copy(obj)
            
            % Default behavior: Create a new object of the same type with no arguments.
            copyObj = feval(class(obj));
            copyObj.StateBounds = obj.StateBounds;
            copyObj.UniformDistribution = obj.UniformDistribution.copy;
            copyObj.NormalDistribution = obj.NormalDistribution.copy;
            
            %--------------------------------------------------------------
            % Place your code here or replace default function behavior.
            %--------------------------------------------------------------
        end
        
        % c) Define how states are forced to lie within the state boundaries.
        %    You have to customize this function if you want to have
        %    special bounding behavior, for example for wrapped states like
        %    angles. The STATE input can be a single state (row) or
        %    multiple states (one state per row).
        %
        %    For more help, see
        %    >> doc nav.StateSpace/enforceStateBounds
        %
        function boundedState = enforceStateBounds(obj, state)
            
            % Default behavior: States are saturated to the [min,max] interval
            nav.internal.validation.validateStateMatrix(state, nan, obj.NumStateVariables, "enforceStateBounds", "state");
            boundedState = state;
            boundedState = min(max(boundedState, obj.StateBounds(:,1)'), ...
                obj.StateBounds(:,2)');
            
            %--------------------------------------------------------------
            % Place your code here or replace default function behavior.
            %--------------------------------------------------------------
        end
        
        % d) Define how you can sample uniformly in your state space.
        %    You need to support the following calling syntaxes:
        %    STATE = sampleUniform(OBJ)
        %    STATE = sampleUniform(OBJ, NUMSAMPLES)
        %    STATE = sampleUniform(OBJ, NEARSTATE, DIST)
        %    STATE = sampleUniform(OBJ, NEARSTATE, DIST, NUMSAMPLES)
        %    You have to customize this function if you deal with angular
        %    state variables.
        %
        %    For more help, see
        %    >> doc nav.StateSpace/sampleUniform
        %
        function state = sampleUniform(obj, varargin)
            
            narginchk(1,4);
            [numSamples, stateBounds] = obj.validateSampleUniformInput(varargin{:});
            
            % Default behavior: Sample uniformly in all state variables
            % based on the user input.a
            obj.UniformDistribution.RandomVariableLimits = stateBounds;
            state = obj.UniformDistribution.sample(numSamples);
            
            %--------------------------------------------------------------
            % Place your code here or replace default function behavior.
            %--------------------------------------------------------------
        end
        
        % e) Define how you can sample a Gaussian distribution in your
        %    state space. You need to support the following calling
        %    syntaxes:
        %    STATE = sampleGaussian(OBJ, MEANSTATE, STDDEV)
        %    STATE = sampleGaussian(OBJ, MEANSTATE, STDDEV, NUMSAMPLES)
        %    You have to customize this function if you deal with angular
        %    state variables.
        %
        %    For more help, see
        %    >> doc nav.StateSpace/sampleGaussian
        %
        function state = sampleGaussian(obj, meanState, stdDev, varargin)
            
            narginchk(3,4);
            
            % Default behavior: Sample from a multi-variate normal
            % distribution based on the user input.
            [meanState, stdDev, numSamples] = obj.validateSampleGaussianInput(meanState, stdDev, varargin{:});
            
            % Configure normal distribution for sampling in all state variables
            obj.NormalDistribution.Mean = meanState;
            obj.NormalDistribution.Covariance = diag(stdDev.^2);
            
            % Sample state(s)
            state = obj.NormalDistribution.sample(numSamples);
            
            % Make sure all state samples are within state bounds. This
            % saturation is not ideal, since it distorts the normal
            % distribution on the state boundaries, but similar to what OMPL is doing.
            state = obj.enforceStateBounds(state);
            
            %--------------------------------------------------------------
            % Place your code here or replace default function behavior.
            %--------------------------------------------------------------
        end
        
        % f) Define how you can interpolate between two states in your
        %    state space. FRACTION is a scalar or a vector, where each number
        %    represents a fraction of the path segment length in the [0,1] interval.
        %
        %    For more help, see
        %    >> doc nav.StateSpace/interpolate
        %
        function interpState = interpolate(obj, state1, state2, fraction)
            
            narginchk(4,4);
            
            % Default behavior: Calculate the linear interpolation between
            % states.
            [state1, state2, fraction] = obj.validateInterpolateInput(state1, state2, fraction);
            
            stateDiff = state2 - state1;
            interpState = state1 + fraction' * stateDiff;
            
            %interpState = state1;
            %--------------------------------------------------------------
            % Place your code here or replace default function behavior.
            %--------------------------------------------------------------
        end
        
        % g) Define how you can calculate the distance between two states in
        %    your state space. The STATE1 and STATE2 inputs can be a single
        %    state (row) or multiple states (one state per row).
        %
        %    For more help, see
        %    >> doc nav.StateSpace/distance
        %
        function dist = distance(obj, state1, state2)
%             try
            narginchk(3,3);
            
            %nav.internal.validation.validateStateMatrix(state1, nan, obj.NumStateVariables, "distance", "state1");
            %nav.internal.validation.validateStateMatrix(state2, size(state1,1), obj.NumStateVariables, "distance", "state2");
            
            % Default behavior: Calculate the Euclidean 2-norm between each pair of
            % state1 and state2 rows
%             stateDiff = bsxfun(@minus, state2, state1);
%             dist = sqrt( sum( stateDiff.^2, 2 ) );
            
            
            state1_ind = ceil(state1);
            state2_ind = ceil(state2);
            
            %--------------------------------------------------------------
            % Place your code here or replace default function behavior.
            %--------------------------------------------------------------
            ny = obj.StateBounds(2,2);
            y1 = state1_ind(:,2);
            x1 = state1_ind(:,1);
            y2 = state2_ind(:,2);
            x2 = state2_ind(:,1);
            ind_1 = y1 + (x1-1)*ny;
            ind_2 = y2 + (x2-1)*ny;
            
            
                dist = obj.TransitionMatrix(ind_1,ind_2,state2_ind(3));
%             catch err
%                 
%             end
        end
        
    end
end

