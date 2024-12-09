//
//  LockView.swift
//  Finance-tracker
//
//  Created by TechnoTackle on 09/12/24.
//

import SwiftUI
import LocalAuthentication

struct LockView<Content: View>: View {
    var lockType: LockType
    var lockPin: String
    var isEnabled: Bool
    var lockWhenAppGoesBackground: Bool = true
    @ViewBuilder var content: Content
    
    @State private var pin: String = ""
    var forgotPin: Bool = true
    @State private var isAnimatedField: Bool = false
    @State private var isUnlocked: Bool = false
    @State private var noBioMetrciAccess: Bool = false
    let context = LAContext()
    @Environment (\.scenePhase) private var phase

    var body: some View {
        GeometryReader {
            let size = $0.size
            
            content
                .frame(width: size.width, height: size.height)
            
            if isEnabled && !isUnlocked {
                Rectangle()
                    .fill(.black)
                    .ignoresSafeArea()
                ZStack {
                    if (lockType == .both && !noBioMetrciAccess) || lockType == .bioMetric {
                        Group {
                            if noBioMetrciAccess {
                                Text("ENable Bio-metric Authentication in settings to unlock the view")
                                    .font(.callout.bold())
                                    .multilineTextAlignment(.center)
                                    .padding(50)
                            } else {
                               //Bio Metric Unlock View
                                VStack(spacing: 15) {
                                    VStack(spacing: 6) {
                                        Image(systemName: "lock")
                                            .font(.largeTitle)
                                        
                                        Text("Tap to unlock")
                                            .font(.caption2)
                                            .foregroundStyle(.gray)
                                    }
                                    .frame(width: 100, height: 100)
                                    .background(.ultraThickMaterial, in: .rect(cornerRadius: 20))
                                    .contentShape(.rect)
                                    
                                    .onTapGesture {
                                        unlockView()
                                    }
                                    
                                    if lockType == .both {
                                        Text("Enter Pin")
                                            .frame(width: 100, height: 40)
                                            .background(.ultraThickMaterial, in: .rect(cornerRadius: 10))
                                            .contentShape(.rect)
                                        
                                            .onTapGesture {
                                               noBioMetrciAccess = true
                                            }
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        NumberPadPinView()
                    }
                }
                .environment(\.colorScheme, .dark)
                .transition(.offset(y: size.height + 100))
            }
        }
        
        .onChange(of: isEnabled, initial: true) { oldValue, newValue in
            if newValue {
                unlockView()
            }
        }
        
        .onChange(of: phase) { oldValue, newValue in
            if newValue != .active && lockWhenAppGoesBackground {
                isUnlocked = false
                pin = ""
            }
            
            if newValue != .active && !isUnlocked && isEnabled {
                unlockView()
            }
        }
    }
    
    ///Lock Type
    enum LockType: String {
        case bioMetric = "Bio Metric Auth"
        case number = "Custom Number Lock"
        case both = "First Preference will be bio-metric, and if it is not available, it will go for number lock."
    }
    
    @ViewBuilder
    private func NumberPadPinView()-> some View {
        VStack(spacing: 15) {
            Text("Enter Pin")
                .font(.title.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    // Back Button Action
                    if lockType == .both /* && isBioMetrciAvailable */ {
                        Button(action: {
                            pin = ""
                            noBioMetrciAccess = false
                        }, label: {
                            Image(systemName: "arrow.left")
                                .font(.title2)
                                .contentShape(.rect)
                        })
                        .tint(.white)
                        .padding(.leading)
                    }
                }
            
            HStack(spacing: 10) {
                ForEach(0..<4, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 10)
//                        .fill(.white)
                        .frame(width: 50, height: 55)
                        .overlay {
                            if pin.count > index {
                                let index = pin.index(pin.startIndex, offsetBy: index)
                                let string = String(pin[index])

                                Text(string)
                                    .font(.title)
                                    .foregroundStyle(.black)
                            }
                        }

                }
            }
            .keyframeAnimator(initialValue: CGFloat.zero, trigger: isAnimatedField, content: { content, value in
                content
                    .offset(x: value)
            }, keyframes: { _ in
                KeyframeTrack {
                    CubicKeyframe(30, duration: 0.06)
                    CubicKeyframe(-30, duration: 0.06)
                    CubicKeyframe(20, duration: 0.06)
                    CubicKeyframe(-20, duration: 0.06)
                    CubicKeyframe(0, duration: 0.06)

                }
            })
            .padding(.top, 15)
            .overlay(alignment: .bottomTrailing) {
                Button(action: {
                    
                }, label: {
                    Text("Forgot Pin?")
                        .font(.callout)
                        .foregroundStyle(.white)
                        .offset(y: 40)
                })
            }
            .frame(maxHeight: .infinity)
            
            
            //Custom Number Pad
            GeometryReader { _ in
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3), content: {
                    ForEach(1...9, id: \.self) { number in
                        Button(action: {
                            //Adding Number to pin
                            //Max Limit 4
                            
                            if pin.count <= 4 {
                                pin.append("\(number)")
                            }
                        }, label: {
                            Text("\(number)")
                                .font(.title)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .contentShape(.rect)
                        })
                        .tint(.white)
                    }
                    
                    Button(action: {
                        if !pin.isEmpty {
                            pin.removeLast()
                        }
                    }, label: {
                        Image(systemName: "delete.backward")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .contentShape(.rect)
                    })
                    .tint(.white)

                    Button(action: {
                        if pin.count <= 4 {
                            pin.append("0")
                        }
                    }, label: {
                        Text("0")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .contentShape(.rect)
                    })
                    .tint(.white)

                    
                })
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            
            .onChange(of: pin) { oldValue, newValue in
                if newValue.count == 4 {
                    if lockPin == pin {
                        print("UnLocked")
                        
                        withAnimation(.snappy, completionCriteria: .logicallyComplete) {
                            isUnlocked = true
                        } completion: {
                            pin = ""
                            noBioMetrciAccess = !isBioMetrciAvailable
                        }
                    } else {
                        print("Wrong Pin")
                        pin = ""
                        isAnimatedField.toggle()
                    }
                }
            }
        }
        .padding()
        .environment(\.colorScheme, .dark)
    }
    
    private func unlockView() {
        Task {
            if isBioMetrciAvailable && lockType != .number {
                ///Requesting BioMetric Access
                if let result = try? await
                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unloack the View"), result {
                    print("Unlockaeddddddd???")
                    
                    withAnimation(.snappy, completionCriteria: .logicallyComplete) {
                        isUnlocked = true
                    } completion: {
                        pin = ""
                    }
                }
            }
            
            //No Biometric Permission || Lock type must be set a keypad
            noBioMetrciAccess = !isBioMetrciAvailable
        }
    }
    
    private var isBioMetrciAvailable: Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
}

#Preview {
    LockView(lockType: .bioMetric, lockPin: "1234", isEnabled: true, content: {
        VStack {
            Text("Welcome").bold()
        }
    })
}
