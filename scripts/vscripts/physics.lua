--[[
    An Easier Physics Class
    Author:XavierCHN
    Date: 2015.02.10
]]
 
PHYSICS_DEBUG = DEBUG_MODE
 
PHYSICS_DEFAULT_ACCELERATION_OF_GRAVITY = -9.8
PHYSICS_DEFAULT_FRICTION_OF_GROUND = 1
PHYSICS_DEFAULT_UNIT_MASS = 1
PHYSICS_DEFAULT_MAX_REBOUNCE_COUNT = 0
PHYSICS_DEFAULT_REBOUNCE_AMP = 0.8
 
PHYSICS_BEHAVIOR_GRIDNAV_NONE = 0
PHYSICS_BEHAVIOR_GRIDNAV_CLIMB = 1
-- PHYSICS_BEHAVIOR_GRIDNAV_REBOUNCE = 2 -- 未完成
 
-- PHYSICS_COLLIDER_TYPE_BOX = 0
-- PHYSICS_COLLIDER_TYPE_WALL = 1
-- PHYSICS_COLLIDER_TYPE_CIRCLE =2
 
if Physics == nil then Physics = class({}) end
 
-- 在这个系统中，1米 = 100 码
-- 质量的单位是 kg
-- 力的单位是 N
-- 速度为向量，每个方向的速度单位均为 m/s
-- 滑动摩擦力系数一般取0.05左右，滚动酌情减少
-- 在这个系统中，目前只考虑地面为水平的情况，地板倾斜的，再议
 
-- 所使用的公式： 复习一下高中知识
-- vt = v0 + a * t
-- s = (v0 + vt) * t / 2
 
-- 使用方法
-- Physics:Unit(unit)
-- unit:SetMass(10) -- 设置质量为10公斤
-- unit:SetFriction(0.05) -- 设置摩擦力系数为0.05
-- unit:SetForce(Vector(100,0,0)) -- 给单位X轴正向100N的推动力
-- unit:SetVelocity(Vector(0,0,100)) -- 给单位Y轴正向1m/s的初速度
-- unit:OnPhysicsFrame(function() return true end) --在每一次计算物理位置的时候，就调用一次参数的函数，必须返回一个非nil值才能继续调用
 
-- [[ API ]]
-- Physics:SetG(g) -- 设置重力加速度，默认为-9.8
-- Physics:Unit(unit) -- 将传入的单位转换为物理运动单位, 返回 physics_unit = Physics:Unit(unit)
-- physics_unit:SetG(g) -- 设置单位的重力加速度，默认为系统重力加速度，如果想让单位不受重力影响，设置这个值为0
-- physics_unit:SetMass(mass) --设置质量
-- physics_unit:GetMass() -- 获取质量
-- physics_unit:GetGravity() -- 获取重量
-- physics_unit:SetFriction() -- 设置地面摩擦力
-- physics_unit:IsOnGround() -- 判断单位是否在地面上
-- physics_unit:SetForce(vForce) -- 设置外力，只设置额外的推动力，摩擦力和重力系统已经自动计算
-- physics_unit:GetFrictionForce() -- 获取所受摩擦力，只有单位在地面上的时候，会受到摩擦力的作用
-- physics_unit:GetForce() -- 获取单位所受的所有力，会自动计算单位的支撑力和重力
-- physics_unit:AddForce(vForce) -- 在当前外力之外增加额外的力，形成合力，如果要清空，用SetForce(Vector(0,0,0))
-- physics_unit:SetMaxRebounce(nMaxRebounce) -- 设置最大反弹次数，默认为0，在这里，所有的反弹都是指的触地反弹，下同
-- physics_unit:GetMaxRebounce() -- 获取最大反弹次数，默认为0
-- physics_unit:CanUnitRebounce() -- 这个单位还可以反弹吗？
-- physics_unit:SetRebounceAmp(loss) -- 设置单位反弹的时候的动能损失， = 反弹后速度/反弹前速度，默认为0.8
-- physics_unit:GetRebounceAmp() -- 获取单位反弹动能损失， = 反弹后速度/反弹前速度，默认为0.8
-- physics_unit:SetVelocity(vVelocity) -- 设定速度，并让他成为单位的当前速度，速度的单位为m/s，一米 = 100 码
-- physics_unit:GetVelocity() -- 获取当前速度
-- physics_unit:GetAcceleration() -- 获取当前加速度，这个值不能设置，只能根据当前受力来获取
-- physics_unit:OnPhysicsFrame(function() return true end) -- 设置每次计算物理位置的时候的回调函数
-- physics_unit:OnGroundRebounce(function() retrun true end) -- 设置每次在地面反弹的回调函数
-- physics_unit:SetGridNavBehavior(behavior) -- 设置在碰到不可通行的位置的时候的处理办法 0 = 无视， 1 = 攀登， 2 = 反弹(反弹未完成)
-- physics_unit:GetGridNavBehavior() -- 设置在碰到不可同行的位置的时候的处理办法，默认为 0 无视
 
-- [[ 范例 ]]
-- function PhysicsBall:Start()
--     local ball = Entities:FindByName(nil, "ent_ball")
--     Physics:Unit(ball)
--     ball:SetMass(0.44) -- 设置足球质量为440g
--     ball:SetMaxRebounce(5) -- 设置足球踢起后最多弹跳5次
--     ball:SetRebounceAmp(0.7) -- 设置反弹损失为0.7
--     ball:SetVelocity(Vector(-10,0,1)) -- 设置速度初始方向为x轴负向，值为10m/s，z方向速度为1m/s
-- end
 
function Physics:Unit(unit)
    -- 设置单位的质量，单位为Kg
    function unit:SetMass(mass)
        unit.fMass = mass
    end
    -- 获取单位的质量，默认为1
    function unit:GetMass()
        return unit.fMass or PHYSICS_DEFAULT_UNIT_MASS
    end
    -- 获取单位所受的重力， = 单位的质量 * 单位重力加速度（默认为系统重力加速度 （默认为 - 9.8m/s^2））
    function unit:GetGravity()
        return unit:GetMass() * unit:GetG()
    end
    -- 设置单位在地面上的摩擦力系数
    function unit:SetFriction(fFriction)
        unit.fFriction = fFriction
    end
    -- 获取单位的摩擦力系数，默认为0.05
    function unit:GetFriction()
        return unit.fFriction or PHYSICS_DEFAULT_FRICTION_OF_GROUND
    end
    -- 判断单位目前是否在地面上，如果比GetGroundPosition低，那么就认为在地面上
    function unit:IsOnGround()
        return unit:GetAbsOrigin().z <= unit:GetPhysicsGroundPosition().z
    end
    function unit:GetPhysicsGroundPosition()
        return GetGroundPosition(unit:GetAbsOrigin(),unit) + Vector(0,0,unit:GetMinHeight())
    end
    -- 设置单位所受的推动力（这个推动力不需要考虑重力和摩擦力等系统力）
    function unit:SetForce(vForce)
        unit.vForce = vForce
    end
    function unit:GetOutForce()
        return unit.vForce or Vector(0,0,0)
    end
    -- 获取单位所受的摩擦力（如果单位在地面上，那么就返回摩擦力，否则，默认空气没有阻力）
    function unit:GetFrictionForce()
        if unit:IsOnGround() then
            -- 摩擦力 = 重力 * 摩擦系数，再设为速度的反向
            return unit:GetMass() * unit:GetFriction() * (0 - unit:GetVelocity():Normalized())
        end
        return Vector(0,0,0)
    end
    -- 获取单位所受的所有力，包括外力和系统力
    function unit:GetForce()
        -- 如果单位在地板上，计算地板的支撑力 和 摩擦力
        if unit:IsOnGround() then
            return unit:GetOutForce() + unit:GetFrictionForce()
        end
        -- 返回值计算入重力
        return unit:GetOutForce() + unit:GetGravity()
    end
    -- 为单位增加额外的推动力，若单位当前没有推动力，则设置单位所受推动力为vForce
    function unit:AddForce(vForce)
        local l = unit.vForce or Vector(0,0,0)
        unit.vForce = l + vForce
    end
    -- 设置单位最大反弹次数限制
    function unit:SetMaxRebounce(nMax)
        unit.nMaxRebounce = nMax
    end
    -- 获取单位最大反弹次数限制，默认为0
    function unit:GetMaxRebounce()
        return unit.nMaxRebounce or PHYSICS_DEFAULT_MAX_REBOUNCE_COUNT
    end
    -- 单位还能反弹吗？
    function unit:CanUnitRebounce()
        if unit.nRebounceCount == nil then
            unit.nRebounceCount = 0
        end
        if unit.nRebounceCount < unit:GetMaxRebounce() then
            unit.nRebounceCount = unit.nRebounceCount + 1
            return true
        else
            unit.nRebounceCount = 0
            return false
        end
        return false
    end
    -- 设置单位在反弹时候的损失
    function unit:SetRebounceAmp(amp)
        unit.vRebounceAmp = amp
    end
    -- 获取单位在反弹时候的损失，默认为0.8
    function unit:GetRebounceAmp()
        return unit.vRebounceAmp or PHYSICS_DEFAULT_REBOUNCE_AMP
    end
    -- 设置单位的当前速度，在外部调用时，适合设置为初始速度
    function unit:SetVelocity(vVelocity)
        unit.vVelocity = vVelocity
    end
    -- 获取单位的当前速度
    function unit:GetVelocity()
        return unit.vVelocity or Vector(0,0,0)
    end
    -- 获取单位的当前加速度 = 单位所受的所有合力 / 单位质量
    function unit:GetAcceleration()
        return unit:GetForce() / unit:GetMass()
    end
    -- 单位在Physics循环的回调
    function unit:OnPhysicsFrame(func)
        unit.funcOnPhysicsFrameCallback = func
    end
    -- 单位在触地反弹时的回调
    function unit:OnGroundRebounce(func)
        unit.funcOnGroundRebounceCallBack = func
    end
    -- 设置单位所受的重力
    function unit:SetG(g)
        unit.g = g
    end
    -- 获取单位所受的重力
    function unit:GetG()
        return unit.g or Physics:GetG()
    end
    -- 设置单位碰到不可通行的位置的状态
    function unit:SetGridNavBehavior(nBehavior)
        unit.nGridNavBehavior = nBehavior
    end
    -- 获取单位碰到不可通行的位置的状态
    function unit:GetGridNavBehavior()
        return unit.nGridNavBehavior or PHYSICS_BEHAVIOR_GRIDNAV_NONE
    end
    -- 获取单位的真实实时速度。
    function unit:GetRealVelocity()
        return unit.vVelocityReal
    end
    -- 设置最低高度
    function unit:SetMinHeight(height)
        unit.fMinHeight = height
    end
    function unit:GetMinHeight()
        return unit.fMinHeight or 0
    end
    function unit:SetMaxHeight(height)
        unit.fMaxHeight = height
    end
    function unit:GetMaxHeight()
        return unit.fMaxHeight
    end
    -- 将单位存入物理总表
    table.insert(Physics.physicsUnits, unit)
 
    -- return unit
end
-- 执行回调函数，如果出现错误，告知错误
function Physics:PerformCallback(unit, func)
    if unit[func] then
        local success, nextCall = pcall(unit[func], unit)
        if success then
            if not nextCall then
                unit[func] = nil
            end
        else
            tPrint("[PHYSICS] CALLBACK ERROR:"..nextCall)
        end
    end
end
-- 每一帧的时候，计算unit这个单位的新位置，并移动他
function Physics:PerformPhysicsMovement(unit, dt)
    -- 获取加速度
    local a = unit:GetAcceleration()
 
    -- 计算新的速度
    local v0 = unit:GetVelocity()
    local vt = v0 + a * dt
 
    -- 计算反弹
    if unit:IsOnGround() and vt.z < 0 then
        -- 如果能反弹，反弹
        if unit:CanUnitRebounce() then
            vt.z = 0 - vt.z
            vt = vt * unit:GetRebounceAmp()
            self:PerformCallback(unit, "funcOnGroundRebounceCallBack")
        else
        -- 如果不能反弹，就在地上滚动
            vt.z = 0
        end
    end
 
    unit:SetVelocity(vt)
 
    -- 计算新的位置
    local p0 = unit:GetAbsOrigin()
    -- 都先用米进行计算，最后得出newPos的时候，把所有距离*100
    -- 鉴于每次的 delta v 都比较小，直接用vt * dt 取代 (v0 + v0 + deltaV = 0) * dt / 2 = v0 * dt
    local pt = p0 + v0 * dt * 100
 
    -- 判断前路是否可以通行
    local cliff = ( not GridNav:IsTraversable(pt) ) or GridNav:IsBlocked(pt)
    -- 根据不同的设置处理新的位置
    if cliff then
        local b = unit:GetGridNavBehavior()
        if b == PHYSICS_BEHAVIOR_GRIDNAV_CLIMB then
            pt = unit:GetPhysicsGroundPosition()
        end
        if b == PHYSICS_BEHAVIOR_GRIDNAV_REBOUNCE then
            -- 如果需要在墙上反弹，那么计算反弹方向
            -- unit:SetVelocity()
            -- pt = 
        end
    end
    unit.vVelocityReal = ( pt - p0 ) / dt
 
    -- 避免球陷入地下
    if pt.z < unit:GetPhysicsGroundPosition().z then pt.z = unit:GetPhysicsGroundPosition().z end
    unit:SetAbsOrigin(pt)
    if DEBUG_MODE then
        DebugDrawLine(pt, pt + vt, 255, 255, 255, true, dt)
        DebugDrawLine(pt, pt + a, 255, 0, 0, true, dt)
    end
end
-- 执行循环，调用每个单位的帧效果
function Physics:OnPhysicsFrame()
    -- 计算dt
    local now = GameRules:GetGameTime()
    if self.__tLastCall == nil then self.__tLastCall = now - 0.03 end
    local dt = now - self.__tLastCall
    self.__tLastCall = now
 
    self.nFrameCount = self.nFrameCount + 1
 
    -- 循环所有单位并展现物理效果
    for _, unit in pairs(self.physicsUnits) do
        self:PerformPhysicsMovement(unit, dt)
        self:PerformCallback(unit, "funcOnPhysicsFrameCallback")
    end
 
end
-- 初始化
function Physics:Start()
    -- 重力加速度
    self.g = Vector(0,0,PHYSICS_DEFAULT_ACCELERATION_OF_GRAVITY)
 
    self.nFrameCount = 0
 
    Timers:CreateTimer(
        function()
            self:OnPhysicsFrame()
            return 0.01
        end
    )
    self.physicsUnits = {}
    self.physicsColliders = {}
 
end
-- 设置系统重力加速度
function Physics:SetG(g)
    self.g = g or Vector(0,0,PHYSICS_DEFAULT_ACCELERATION_OF_GRAVITY)
end
-- 获取系统重力加速度
function Physics:GetG()
    return self.g
end
 
Physics:Start()