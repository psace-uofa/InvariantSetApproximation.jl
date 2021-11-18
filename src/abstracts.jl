

"""
AbstractSystem

An abstract type representing a system
"""
abstract type AbstractSystem end

"""
state_dim(s::AbstractSystem)

Return the state dimension of a system
"""
state_dim(s::AbstractSystem) = s.state_dim

"""
state_set(s::AbstractSystem)

Return the state dimension of a system
"""
state_set(s::AbstractSystem) = s.X

"""
has_input(s::AbstractSystem)

Return the input condition of a system
"""
has_input(s::AbstractSystem) = false

"""
has_uncertainty(s::AbstractSystem)

Return the uncertainty condition of a system
"""
has_uncertainty(s::AbstractSystem) = false

"""
AbstractUncertainSystem

An abstract type representing an uncertain system
"""
abstract type AbstractUncertainSystem <:AbstractSystem end

"""
uncertainty_dim(s::AbstractUncertainSystem)

Return the uncertainty dimension of a system
"""
uncertainty_dim(s::AbstractUncertainSystem) = s.uncertainty_dim

"""
has_uncertainty(s::AbstractUncertainSystem)

Return the uncertainty condition of a system
"""
has_uncertainty(s::AbstractUncertainSystem) = true

"""
uncertainty_set(s::AbstractUncertainSystem)

Return the uncertainty set of a system
"""
uncertainty_set(s::AbstractUncertainSystem) = s.W

"""
AbstractControlSystem

An abstract type representing a control system
"""
abstract type AbstractControlSystem <:AbstractSystem end

"""
input_dim(s::AbstractControlSystem)

Return the input dimension of a control system
"""
input_dim(s::AbstractControlSystem) = s.input_dim

"""
has_input(s::AbstractControlSystem)

Return the input condition of a system
"""
has_input(s::AbstractControlSystem) = true

"""
input_set(s::AbstractControlSystem)

Return the input constraint of a control system
"""
input_set(s::AbstractControlSystem) = s.U

"""
AbstractUncertainControlSystem

An abstract type representing a control system with uncertainties
"""
abstract type AbstractUncertainControlSystem <:AbstractUncertainSystem end

"""
input_dim(s::AbstractUncertainControlSystem)

Return the input dimension of a control system
"""
input_dim(s::AbstractUncertainControlSystem) = s.input_dim

"""
has_input(s::AbstractUncertainControlSystem)

Return the input condition of a system
"""
has_input(s::AbstractUncertainControlSystem) = true

"""
input_set(s::AbstractUncertainControlSystem)

Return the input constraint of a control system
"""
input_set(s::AbstractUncertainControlSystem) = s.U

"""
AbstractSolver

An abstract solver object
"""
abstract type AbstractSolver end


"""
AbstractOptions

An abstract options object
"""
abstract type AbstractOptions end


"""
AbstractSolution

An abstract solution object
"""
abstract type AbstractSolution end
