
#!/usr/bin/env bash

set -u

PASS=0
FAIL=0

echo "=========================================="
echo "       WEEK 1 BOOTCAMP VERIFICATION"
echo "=========================================="
echo

# --------------------------------------------------
# Helper functions
# --------------------------------------------------

pass() {
    echo "✅ PASS: $1"
    ((PASS++))
}

fail() {
    echo "❌ FAIL: $1"
    ((FAIL++))
}

# --------------------------------------------------
# PART 1: Required Software
# --------------------------------------------------

echo "=========================================="
echo " PART 1: REQUIRED SOFTWARE"
echo "=========================================="
echo

check_command() {
    local name="$1"
    local command="$2"

    if command -v "$command" >/dev/null 2>&1; then
        pass "$name is installed"
    else
        fail "$name is not installed"
    fi
}

check_command "Docker" docker
check_command "kubectl" kubectl
check_command "Kind" kind
check_command "Git" git
check_command "Python 3" python3
check_command "VS Code" code
check_command "Helm" helm

echo

# --------------------------------------------------
# Display versions
# --------------------------------------------------

echo "=========================================="
echo " INSTALLED VERSIONS"
echo "=========================================="
echo

if command -v docker >/dev/null 2>&1; then
    echo "Docker:   $(docker --version)"
fi

if command -v kubectl >/dev/null 2>&1; then
    echo "kubectl:  $(kubectl version --client --output=yaml 2>/dev/null | grep gitVersion | head -n 1 | xargs)"
fi

if command -v kind >/dev/null 2>&1; then
    echo "Kind:     $(kind version)"
fi

if command -v git >/dev/null 2>&1; then
    echo "Git:      $(git --version)"
fi

if command -v python3 >/dev/null 2>&1; then
    echo "Python:   $(python3 --version)"
fi

if command -v code >/dev/null 2>&1; then
    echo "VS Code:  $(code --version 2>/dev/null | head -n 1)"
fi

if command -v helm >/dev/null 2>&1; then
    echo "Helm:     $(helm version --short 2>/dev/null)"
fi

echo

# --------------------------------------------------
# PART 2: Kind Extra Challenge
# --------------------------------------------------

echo "=========================================="
echo " PART 2: KIND EXTRA CHALLENGE"
echo "=========================================="
echo

# We need Kind and kubectl for this section.

if ! command -v kind >/dev/null 2>&1; then
    fail "Cannot verify Kind cluster because Kind is not installed"
else

    if ! command -v kubectl >/dev/null 2>&1; then
        fail "Cannot verify Kind cluster because kubectl is not installed"
    else

        # --------------------------------------------------
        # Check Kind cluster exists
        # --------------------------------------------------

        echo "Checking for Kind cluster..."

        CLUSTERS=$(kind get clusters 2>/dev/null)

        if [ -z "$CLUSTERS" ]; then

            fail "No Kind cluster exists"

        else

            echo
            echo "Kind clusters found:"
            echo "$CLUSTERS"
            echo

            # Determine cluster name.
            CURRENT_CONTEXT=$(kubectl config current-context 2>/dev/null || true)

            if [[ "$CURRENT_CONTEXT" == kind-* ]]; then
                CLUSTER_NAME="${CURRENT_CONTEXT#kind-}"
            else
                CLUSTER_NAME=$(echo "$CLUSTERS" | head -n 1)
            fi

            pass "Kind cluster exists: $CLUSTER_NAME"

            # --------------------------------------------------
            # Check kubeconfig context
            # --------------------------------------------------

            echo
            echo "Checking kubeconfig..."

            if kubectl config get-contexts "kind-$CLUSTER_NAME" \
                >/dev/null 2>&1; then

                pass "Kubeconfig contains kind-$CLUSTER_NAME"

            else

                fail "Kubeconfig does not contain kind-$CLUSTER_NAME"

            fi

            # --------------------------------------------------
            # Check Kubernetes API access
            # --------------------------------------------------

            echo
            echo "Testing Kubernetes API access..."

            if kubectl --context="kind-$CLUSTER_NAME" cluster-info \
                >/dev/null 2>&1; then

                pass "Kubeconfig successfully connects to cluster"

            else

                fail "Kubeconfig cannot connect to cluster"

            fi

            # --------------------------------------------------
            # Get nodes
            # --------------------------------------------------

            echo
            echo "Checking Kubernetes nodes..."

            NODES=$(
                kubectl --context="kind-$CLUSTER_NAME" get nodes \
                --no-headers 2>/dev/null
            )

            if [ -z "$NODES" ]; then

                fail "No Kubernetes nodes found"

            else

                echo
                kubectl --context="kind-$CLUSTER_NAME" get nodes
                echo

                NODE_COUNT=$(echo "$NODES" | wc -l)

                # --------------------------------------------------
                # Check exactly 3 nodes
                # --------------------------------------------------

                if [ "$NODE_COUNT" -eq 3 ]; then

                    pass "Cluster has exactly 3 nodes"

                else

                    fail "Cluster has $NODE_COUNT nodes; expected 3"

                fi

                # --------------------------------------------------
                # Check control-plane
                # --------------------------------------------------

                CONTROL_PLANE_COUNT=$(
                    kubectl --context="kind-$CLUSTER_NAME" get nodes \
                    -l node-role.kubernetes.io/control-plane \
                    --no-headers 2>/dev/null | wc -l
                )

                if [ "$CONTROL_PLANE_COUNT" -eq 1 ]; then

                    CONTROL_PLANE_NODE=$(
                        kubectl --context="kind-$CLUSTER_NAME" get nodes \
                        -l node-role.kubernetes.io/control-plane \
                        -o jsonpath='{.items[0].metadata.name}'
                    )

                    pass "One control-plane node found: $CONTROL_PLANE_NODE"

                else

                    fail "Expected 1 control-plane node; found $CONTROL_PLANE_COUNT"

                fi

                # --------------------------------------------------
                # Check workers
                # --------------------------------------------------

                WORKER_COUNT=$(
                    kubectl --context="kind-$CLUSTER_NAME" get nodes \
                    -l '!node-role.kubernetes.io/control-plane' \
                    --no-headers 2>/dev/null | wc -l
                )

                if [ "$WORKER_COUNT" -eq 2 ]; then

                    pass "Exactly 2 worker nodes found"

                else

                    fail "Expected 2 worker nodes; found $WORKER_COUNT"

                fi

            fi
        fi
    fi
fi

# --------------------------------------------------
# FINAL SCORE
# --------------------------------------------------

echo
echo "=========================================="
echo "          VERIFICATION SUMMARY"
echo "=========================================="
echo

echo "Passed checks : $PASS"
echo "Failed checks : $FAIL"

TOTAL=$((PASS + FAIL))

if [ "$TOTAL" -gt 0 ]; then
    SCORE=$((PASS * 100 / TOTAL))
else
    SCORE=0
fi

echo "Verification score: $SCORE%"
echo

if [ "$FAIL" -eq 0 ]; then

    echo "🎉 WEEK 1 VERIFICATION PASSED!"
    echo
    echo "All required software and the Kind Extra Challenge"
    echo "have been successfully verified."

else

    echo "⚠️ WEEK 1 VERIFICATION INCOMPLETE"
    echo
    echo "Fix the failed checks and run the script again."

fi

echo
echo "=========================================="


